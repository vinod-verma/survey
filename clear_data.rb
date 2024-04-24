require 'pstore'

stores = [PStore.new("tendable.pstore"), PStore.new("test.pstore")] 

# Open the PStore file in write mode to clear all data
stores.each do |store|
  store.transaction do
    store.roots.each { |key| store.delete(key) }  # Delete all keys and data
  end
end