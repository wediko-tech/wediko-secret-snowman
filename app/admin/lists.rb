ActiveAdmin.register List, as: "Wishlist" do
  actions :all, except: [:create, :new]

  # A list of fields by which the user can filter on the index page
  filter :title
  filter :description
  filter :by_therapist_name_in, as: :string, label: "THERAPIST NAME"
  filter :by_event_name_in, as: :string, label: "EVENT NAME"

  # Each of these scopes appears as a selectable 'tab' on the index page
  scope :all, default: true
  scope :empty
  scope :non_empty

  member_action :delete_requests, method: :delete do
    if list = List.find_by(id: params[:id])
      list.gift_requests.destroy_all
      redirect_to admin_wishlist_path(list), notice: "Gift requests deleted."
    else
      redirect_to admin_wishlists_path, alert: "Could not find wishlist."
    end
  end

  action_item :delete_requests, only: :show, if: proc{ wishlist.gift_requests.any? } do
    link_to "Delete all requests", delete_requests_admin_wishlist_path(wishlist),
      data: {confirm: "Are you sure you want to delete all requests attached to this wishlist?"},
      method: :delete
  end

  index do
    selectable_column
    actions
    column :title do |l|
      link_to l.title, admin_wishlist_path(l)
    end
    column :event do |l|
      link_to l.event.title, admin_event_path(l.event)
    end
    column :description do |l|
      l.description.truncate(50, ommission: "...")
    end
    column :therapist do |l|
      link_to l.therapist.name, admin_user_path(l.therapist.user)
    end
    column :requests do |l|
      l.gift_requests.count
    end
  end

  csv do
    column :title
    column :event do |l|
      l.event.title
    end
    column :description
    column :therapist do |l|
      l.therapist.name
    end
    column :requests do |l|
      l.gift_requests.count
    end
  end

  show do
    attributes_table do
      row :therapist do |l|
        link_to l.therapist.name, admin_user_path(l.therapist.user)
      end
      row :event do |l|
        link_to l.event.title, admin_event_path(l.event)
      end
      row :title
      row :description
    end

    if wishlist.gift_requests.any?
      panel "Requests" do
        table_for wishlist.gift_requests do
          column :recipient do |gr|
            link_to gr.recipient, admin_gift_request_path(gr)
          end
          column :description do |gr|
            gr.description.truncate(50, ommission: "...")
          end
          column :link do |gr|
            link_to gr.link, gr.link
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

    f.inputs "Association" do
      f.input :therapist
      f.input :event, collection: Event.active
    end

    f.actions
  end
end
