ActiveAdmin.register User do
  after_create do |user|
    # set role
    case params[:user][:role_type]
    when 'admin'
      user.role = Administrator.create
    when 'therapist'
      user.role = Therapist.create
    when 'donor'
      user.role = Donor.create
    end

    user.save!
  end

  index do
    selectable_column
    column :email
    column :name
    column :role_type
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :role_type
      row :created_at
    end
  end

  filter :email
  filter :created_at
  filter :role_type # make select

  #scope :donors
  #scope :therapists
  # scope :admins

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Login Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.inputs "Profile Details" do
      f.input :name
      f.input :role_type, display: "Role", as: :radio, required: true,
        collection: preselected_collection([
          ["Administrator", :admin],
          ["Therapist", :therapist],
          ["Donor", :donor]
        ], params[:role])
    end
    f.actions
  end
end
