# frozen_string_literal: true

RSpec.describe 'Sip Options Probers', js: true do
  include_context :login_as_admin

  let!(:nodes) { create_list(:node, 2) }
  let(:record_attributes) do
    [
      FactoryBot.attributes_for(:sip_options_prober, :filled, node_id: nodes.first.id),
      FactoryBot.attributes_for(:sip_options_prober, :filled, node_id: nodes.second.id)
    ]
  end

  before do
    stub_jrpc_request('options_prober.show.probers', nodes.first.rpc_endpoint, { logger: be_present })
      .and_return([record_attributes.first.stringify_keys])
    stub_jrpc_request('options_prober.show.probers', nodes.second.rpc_endpoint, { logger: be_present })
      .and_return([record_attributes.second.stringify_keys])
  end

  describe 'index page' do
    subject do
      visit sip_options_probers_path
    end

    it 'returns correct Sip Options Probers' do
      subject

      expect(page).to have_table
      expect(page).to have_table_row count: nodes.size
      nodes.each { |node| expect(page).to have_link(node.name, href: node_path(node.id)) }
      record_attributes.each do |record_attribute|
        expect(page).to have_link(record_attribute[:name], href: equipment_sip_options_prober_path(record_attribute[:id]))
      end
      record_attributes.each { |record_attribute| expect(page).to have_table_cell column: 'Id', text: record_attribute[:id] }
    end
  end

  describe 'show page' do
    subject do
      visit sip_options_probers_path
      click_link(href: sip_options_prober_path("#{nodes.first[:id]}*#{record_attributes.first[:id]}"))
    end

    before do
      stub_jrpc_request('options_prober.show.probers', nodes.first.rpc_endpoint, { logger: be_present })
        .with(record_attributes.first[:id].to_s)
        .and_return([record_attributes.first.stringify_keys])
    end

    it 'returns correct Sip Options Prober{#id}' do
      subject

      expect(page).to have_attribute_row('ID', exact_text: record_attributes.first[:id])
      record_attributes.first.each do |attribute, _value|
        next if attribute == :node_id

        expect(page).to have_attribute_row(attribute.to_s.upcase)
      end
    end
  end
end
