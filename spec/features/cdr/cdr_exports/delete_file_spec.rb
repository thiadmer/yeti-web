# frozen_string_literal: true

RSpec.describe 'CDR exports', type: :feature, js: true do
  include_context :login_as_admin

  describe 'delete_file' do
    subject do
      click_link('Delete File')
    end

    let!(:cdr_export) { create(:cdr_export, :completed) }

    before do
      visit cdr_export_path(cdr_export.id)
    end

    it 'cdr export should be displayed' do
      expect { subject }.to change { cdr_export.reload.status }
        .from(CdrExport::STATUS_COMPLETED)
        .to(CdrExport::STATUS_DELETED)
    end

    include_examples :shows_flash_message, :notice, 'The file will be deleted in background!'
  end
end
