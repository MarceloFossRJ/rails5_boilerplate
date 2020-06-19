class MembersController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Member.by_workspace_subdomain(current_workspace.subdomain).ransack(params[:q])
    @q.sorts = 'user_id desc' if @q.sorts.empty?
    @members = @q.result(distinct: true).page params[:page]
    @invitations = Invitation.by_workspace(current_workspace.id).pending.page params[:page] # find_by_workspace_id(current_workspace.id)
    @invitation = Invitation.new
    authorize @invitation
  end

  def create
    @invitation = Invitation.new(invitation_params) # Make a new Invite
    authorize @invitation
    @invitation.sender_id = current_user.id # set the sender to the current user
    @invitation.workspace_id = current_workspace.id
    @invitation.create_with_transaction(invitation_params)
    respond_to do |format|
      if @invitation.persisted?
        InviteMailer.workspace_invitation(@invitation).deliver #send the invite data to our mailer to deliver the email
        @invitation.sent_at = Time.now
        @invitation.count = 1
        @invitation.save
        format.html { redirect_to members_path, notice: "Invitation successfully sent to #{@invitation.email}." }
      else
        format.html { redirect_to members_path, alert: "#{@invitation.errors.details}" }
      end
    end
  end

  def resend_invitation
    invitation = Invitation.find(params[:id])
    authorize invitation
    respond_to do |format|
      count = invitation.count.to_i + 1
      invitation.count = count
      if invitation.save
        InviteMailer.workspace_invitation(invitation).deliver #send the invite data to our mailer to deliver the email
        invitation.sent_at = Time.now
        invitation.count = invitation.count.to_i + 1
        invitation.save
        format.html { redirect_to members_path, notice: "Invitation successfully sent to #{invitation.email}." }
      else
        format.html { redirect_to members_path, alert: "Already sent invitations #{count - 1} times" }
      end
    end
  end

  def remove_invitation
    @invitation = Invitation.find(params[:id])
    authorize @invitation
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to members_path, notice: 'Invitation was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def destroy
    @member = Member.find(params[:id])
    authorize @member
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_path, notice: 'Member was successfully removed.' }
      format.json { head :no_content }
    end

  end

  # respond to PUT /members/:id
  def update
    @member = Member.find(params[:id])
    authorize @member
    @member.role = params[:role]
    respond_to do |format|
      if @member.save!
        format.json { render json: {status: :ok} }
      else
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def invitation_params
    params.require(:invitation).permit(:email,
                                    :workspace_id)
  end

  def sort_column
    Member.column_names.include?(params[:sort]) ? params[:sort] : "user_id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
