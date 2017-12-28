require File.dirname( __FILE__ ) + '/database_configuration'

require 'database_cleaner'
require 'minitest/spec'
require 'invoice_numbers'

require File.dirname( __FILE__ ) + '/models'

describe Invoice do
  before do
    @invoice = Invoice.new(:customer => "jan")
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  it 'assigns an invoice number when forced' do
    @invoice.assign_invoice_number
    @invoice.save
    @invoice.invoice_nr.must_equal "jan1"
  end

  it 'uses the shared sequence' do
    invoice2 = Invoice.new(:customer => "henk")
    invoice2.assign_invoice_number
    invoice2.invoice_nr.must_equal "henk1"
    invoice3 = Invoice.new(:customer => "henk")
    invoice3.assign_invoice_number
    invoice3.invoice_nr.must_equal "henk2"
    @invoice.assign_invoice_number
    @invoice.invoice_nr.must_equal "jan1"
  end

end

describe Reservation do
  before do
    @reservation = Reservation.new
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  it 'does not assign an invoice number' do
    @reservation.save
    @reservation.invoice_nr.must_be_nil
  end

  it 'assigns and increments invoice numbers when forced' do
    @reservation.assign_invoice_number
    @reservation.save
    @reservation.invoice_nr.must_equal "R[#{@reservation.object_id}]1"

    other_reservation = Reservation.new
    other_reservation.assign_invoice_number
    other_reservation.save
    other_reservation.invoice_nr.must_equal "R[#{other_reservation.object_id}]2"
  end

  it 'uses the shared sequence' do
    InvoiceNumbers::Generator.next_invoice_number(:shared)
    InvoiceNumbers::Generator.next_invoice_number(:shared)
    @reservation.assign_invoice_number
    @reservation.invoice_nr.must_equal "R[#{@reservation.object_id}]3"
  end
end

describe Order do
  before do
    @order = Order.new
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  it 'does not assign an invoice number' do
    @order.save
    @order.invoice_nr.must_be_nil
  end

  it 'assigns an invoice number when finished' do
    @order.finished = true
    @order.save
    @order.invoice_nr.must_equal 1.to_s
  end

  it 'does not update an invoice number once assigned' do
    @order.finished = true
    @order.save
    @order.invoice_nr.must_equal 1.to_s
    @order.invoice_nr_will_change! # force a new save
    @order.save
    @order.invoice_nr.must_equal 1.to_s
  end

  it 'uses the order sequence' do
    InvoiceNumbers::Generator.next_invoice_number(:order)
    InvoiceNumbers::Generator.next_invoice_number(:order)
    @order.finished = true
    @order.assign_invoice_nr
    @order.invoice_nr.must_equal 3.to_s
  end
end
