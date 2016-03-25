ActiveAdmin.register GiftRequest do
  actions :index, :show, :delete

  # A list of fields by which the user can filter on the index page
  filter :link
  filter :list
  filter :recipient

  # Each of these scopes appears as a selectable 'tab' on the index page
  scope :all, default: true
  scope :reserved
  scope :unreserved

  index do
    selectable_column
    actions
    column :link do |gr|
      link_to gr.link, gr.link
    end
    column :recipient
    column :description do |gr|
      gr.description.truncate(50, ommission: "...")
    end
    column :list do |gr|
      link_to gr.list.title, admin_wishlist_path(gr.list)
    end
    column :reservation do |gr|
      if gr.reservation.present?
        link_to gr.reservation.status.capitalize,
          admin_reservation_path(gr.reservation)
      else
        "Unreserved"
      end
    end
  end

  show do
    attributes_table do
      row :list do |gr|
        link_to gr.list.title, admin_wishlist_path(gr.list)
      end
      row :link
      row :recipient
      row :description do |gr|
        gr.description
      end
      row :status
    end

    # show reservation?
  end
end
