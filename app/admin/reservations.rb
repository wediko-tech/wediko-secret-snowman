ActiveAdmin.register Reservation do
  actions :all, except: [:create, :new]

  # Each of these scopes appears as a selectable 'tab' on the index page
  scope :all, default: true
  scope :received
  scope :unreceived

  # A list of fields by which the user can filter on the index page
  filter :state, as: :select
  filter :delinquent
  filter :tracking_number

  member_action :mark_received, method: :patch do
    if reservation = Reservation.find_by(id: params[:id])
      if reservation.can_receive?
        reservation.receive!
        flash = {notice: "Marked as received."}
      else
        flash = {alert: "Reservation cannot be marked as received. Our records show it is currently '#{reservation.state}'."}
      end

      redirect_to admin_reservation_path(reservation), flash
    else
      redirect_to admin_reservations_path, alert: "Could not find the reservation."
    end
  end

  action_item :mark_received, only: :show, if: proc{ reservation.can_receive? } do
    link_to "Mark As Received", mark_received_admin_reservation_path(reservation), method: :patch
  end

  index do
    selectable_column
    actions
    column :gift_request do |r|
      link_to "#{r.gift_request.recipient}: #{r.gift_request.link}",
        admin_gift_request_path(r.gift_request)
    end
    column :donor do |r|
      link_to r.donor.name, admin_user_path(r.donor.user)
    end
    column :status do |r|
      status_tag r.status
    end
    column :tracking_number do |r|
      if r.reserved? || r.tracking_number.blank?
        "[None]"
      else
        r.tracking_number
      end
    end
  end

  csv do
    column :gift_request do |r|
      "#{r.gift_request.recipient}: #{r.gift_request.link}"
    end
    column :donor do |r|
      r.donor.name
    end
    column :status
    column :tracking_number do |r|
      if r.reserved? || r.tracking_number.blank?
        "[None]"
      else
        r.tracking_number
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :gift_request do |r|
        link_to "#{r.gift_request.recipient}: #{r.gift_request.link}",
          admin_gift_request_path(r.gift_request)
      end
      row :donor do |r|
        link_to r.donor.name, admin_user_path(r.donor.user)
      end
      row :status do |r|
        status_tag r.status
      end
      row :tracking_number do |r|
        if r.reserved? || r.tracking_number.blank?
          "[None]"
        else
          r.tracking_number
        end
      end
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.actions
  end
end
