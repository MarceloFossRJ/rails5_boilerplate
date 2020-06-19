class InviteMailer < ApplicationMailer
  def workspace_invitation(invitation)
    if invitation.recipient_id.nil?
      workspace = Workspace.find(invitation.workspace_id)
      mail(   to:       invitation.email,
              from:     "SENDER EMAIL",
              subject:  "Invitation to join #{workspace.name} at APPLICATION NAME"
      ) do |format|

          @invitation = invitation
          @workspace = workspace
          @sender = User.find(invitation.sender_id)
          format.html
      end
    else
      workspace_inclusion(invitation)
    end
  end

  def workspace_inclusion(invitation)
    workspace = Workspace.find(invitation.workspace_id)
    mail(   to:       invitation.email,
            from:     "SENDER EMAIL",
            subject:  "Invitation to join #{workspace.name} at APPLICATION NAME"
    ) do |format|

      @invitation = invitation
      @workspace = workspace
      @sender = User.find(invitation.sender_id)
      format.html
    end
  end

end
# TODO REPLACE APPLICATION NAME
# TODO REPLACE SENDER