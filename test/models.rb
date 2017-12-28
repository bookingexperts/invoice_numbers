if ENV['orm'].nil? || ENV['orm'] == 'activerecord'

  ActiveRecord::Schema.define :version => 1 do
    create_table :orders, :force => true do |t|
      t.boolean :finished,    :default => false
      t.string :dummy_nr
      t.string :invoice_nr
    end
    create_table :reservations, :force => true do |t|
      t.boolean :finished,    :default => false
      t.string :invoice_nr
    end
    create_table :invoices, :force => true do |t|
      t.boolean :finished,    :default => false
      t.string :invoice_nr
      t.string  :customer
     end
  end

  class Order < ActiveRecord::Base
    has_invoice_number :invoice_nr, :assign_if => lambda { |order| order.finished? }
    has_invoice_number :dummy_nr,   :invoice_number_sequence => :dummy
  end

  class Reservation < ActiveRecord::Base
    has_invoice_number :invoice_nr, :invoice_number_sequence => :shared, :prefix => lambda { |reservation| "R[#{reservation.object_id}]" }
  end

  class Invoice < ActiveRecord::Base
    has_invoice_number :invoice_nr, :invoice_number_sequence => lambda { |invoice| "#{invoice.customer}" }, :prefix => true
  end

elsif ENV['orm'] == 'mongoid'

  class Order
    include Mongoid::Document
    include InvoiceNumbers::InvoiceNumbers

    field :finished, 	type: Boolean, default: false
    field :dummy_nr, 	type: String
    field :invoice_nr, 	type: String

    has_invoice_number :invoice_nr, :assign_if => lambda { |order| order.finished? }
    has_invoice_number :dummy_nr,   :invoice_number_sequence => :dummy
  end

  class Reservation
    include Mongoid::Document
    include InvoiceNumbers::InvoiceNumbers

    field :finished, 	type: Boolean, default: false
    field :invoice_nr, 	type: String

    has_invoice_number :invoice_nr, :invoice_number_sequence => :shared
  end

  class Invoice
    include Mongoid::Document
    include InvoiceNumbers::InvoiceNumbers

    field :finished, 	type: Boolean, default: false
    field :invoice_nr, 	type: String
    field :dummy_nr, 	type: String
    field :customer, 	type: String

    has_invoice_number :invoice_nr, :invoice_number_sequence => lambda { |invoice| "#{invoice.customer}" }, :prefix => true
  end

end
