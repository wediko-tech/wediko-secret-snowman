ActiveAdmin.register User do
  before_create :create_user_role

  # A list of fields by which the user can filter on the index page
  filter :email
  filter :created_at
  filter :role_type

  # Each of these scopes appears as a selectable 'tab' on the index page
  scope :all, default: true
  scope :donors
  scope :therapists
  scope :admins

  # Details the appearance of the user index
  index do
    # Column with a checkbox that lets you select a row for batch actions
    selectable_column
    # View, edit, delete, depending on which actions are enabled
    actions
    column :email
    column :phone_number
    column :name
    column :role_type
    column :created_at
  end

  csv do
    column :email
    column :name
    column :role_type
    column :created_at
    column :phone_number
    column :address_line_1
    column :address_line_2
    column :address_city
    column :address_state
    column :address_zip_code
  end

  # Details the appearance of the individual user detail page
  show do
    attributes_table do
      row :name
      row :email
      row :phone_number
      row :role_type
      row :created_at
      row :phone_number
    end

    panel "Address" do
      attributes_table do
        row :address_line_1
        row :address_line_2
        row :address_city
        row :address_state
        row :address_zip_code
      end
    end
  end

  # Adds a conditional sidebar to the show page for users
  sidebar "Wishlists", only: :show, if: proc{ user.therapist? } do
    if user.role.lists.any?
      table_for user.role.lists do
        column :title do |l|
          link_to l.title, admin_wishlist_path(l)
        end
        column :requests do |l|
          l.gift_requests.count
        end
      end
    else
      h5 "No Wishlists"
    end
  end

  sidebar "Reservations", only: :show, if: proc{ user.donor? } do
    if user.role.reservations.any?
      table_for user.role.reservations do
        column :gift_request do |r|
          link_to "#{r.gift_request.recipient}: #{r.gift_request.link}",
            admin_gift_request_path(r.gift_request)
        end

        column :status do |r|
          status_tag r.status
        end
      end
    else
      h5 "No Reservations"
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Login Details" do
      f.input :email
      f.input :password, required: f.object.new_record?,
        hint: ("Leave the field blank to keep the current password." unless f.object.new_record?)
      f.input :password_confirmation
    end
    f.inputs "Profile Details" do
      f.input :name
      if f.object.new_record?
        f.input :role_type, display: "Role", as: :radio, required: true,
          collection: ["Administrator", "Donor", "Therapist"]
      else
        li do
          f.label "Role type"
          para f.object.role_type, title: "Role cannot be changed after a user is created."
        end
      end
    end
    f.actions
  end

  controller do
    # set role after creation
    def create_user_role(user)
      role_type = params[:user][:role_type]

      case role_type
      when 'Administrator'
        user.role = Administrator.create
      when 'Therapist'
        user.role = Therapist.create
      when 'Donor'
        user.role = Donor.create
      else
        flash[:alert] = "Unknown role #{role_type}. Defaulting user to Donor."
        user.role = Donor.create
      end
    end

    def update
      @user = User.find(params[:id])

      if params[:user][:password].blank?
        @user.update_without_password(permitted_params[:user])
      else
        @user.update(permitted_params[:user])
      end

      if @user.errors.blank?
        redirect_to admin_user_path(@user), notice: "User updated successfully."
      else
        render :edit
      end
    end
  end
end
