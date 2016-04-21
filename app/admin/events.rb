ActiveAdmin.register Event do
  scope :all
  scope :active, default: true
  scope :inactive

  filter :by_wishlist_title_in, as: :string, label: "WITH WISHLIST TITLE"
  filter :start_date
  filter :end_date

  index do
    selectable_column
    actions
    column :title do |e|
      link_to e.title, admin_event_path(e)
    end
    column :description do |e|
      e.description.truncate(50, ommission: "...")
    end
    column :dates do |e|
      "#{e.start_date.to_date} to #{e.end_date.to_date}"
    end
    column :active do |e|
      status_tag(DateTime.current.between?(e.start_date, e.end_date))
    end
  end

  csv do
    column :title
    column :description
    column :start_date
    column :end_date
    column :active do |e|
      DateTime.current.between?(e.start_date, e.end_date)
    end
  end

  show do
    attributes_table do
      row :title
      row :description
      row :start_date
      row :end_date
    end

    if event.lists.any?
      panel "Wishlists" do
        table_for event.lists do
          column :title do |wl|
            link_to wl.title, admin_wishlist_path(wl)
          end
          column :therapist do |wl|
            user = wl.therapist.user
            link_to user.name, admin_user_path(user)
          end
          column :description do |wl|
            wl.description.truncate(50, ommission: "...")
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Descriptors" do
      f.input :title
      f.input :description
    end

    f.inputs "Dates" do
      f.input :start_date, as: :date_select
      f.input :end_date, as: :date_select
    end

    f.actions
  end
end
