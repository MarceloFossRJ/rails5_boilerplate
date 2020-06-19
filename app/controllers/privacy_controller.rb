class PrivacyController < ApplicationController
  before_action :set_variables

  def index
  end

  def set_variables
    @company_name ||= Variables::Company::CompanyName
    @company_website ||= Variables::Company::CompanyWebsite
  end
end
