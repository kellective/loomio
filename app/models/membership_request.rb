class MembershipRequest < ActiveRecord::Base

  attr_accessible :name, :email, :introduction

  validates :name,  presence: true
  validates :email, presence: true, email: true #this uses the gem 'valid_email'

  validate :not_in_group_already
  validate :unique_membership_request
  # validates_presence_of :responder if 'response.present?'

  validates :group, presence: true

  belongs_to :group
  belongs_to :user
  # belongs_to :responder

  delegate :members,             to: :group, prefix: true
  delegate :membership_requests, to: :group, prefix: true

  def name
    if requestor.present?
      requestor.name
    else
      self[:name]
    end
  end

  def email
    if requestor.present?
      requestor.email
    else
      self[:email]
    end
  end

  def approve!

  end

  def requestor
    user
  end

  private

  def not_in_group_already
    if group_members.find_by_email(email)
      errors.add(:email, 'this address belongs to someone already in this group.') #needs_translation see simple_form yaml?
    end
  end

  def unique_membership_request
    if group_membership_requests.find_by_email(email)
      errors.add(:email, 'you have already requested membership') #needs_translation
    end
  end
end
