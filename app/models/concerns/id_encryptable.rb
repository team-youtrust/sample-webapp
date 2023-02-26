module IdEncryptable
  extend ActiveSupport::Concern

  included do
    def self.encrypt_id(id)
      return nil if id.blank?

      cipher = OpenSSL::Cipher.new('AES-256-CBC').encrypt
      cipher.key = id_cipher_key
      binary = cipher.update(id.to_s) + cipher.final
      binary.unpack1('H*')
    rescue OpenSSL::Cipher::CipherError
      nil
    end

    def self.decrypt_id(enc_id)
      return nil if enc_id.blank?

      cipher = OpenSSL::Cipher.new('AES-256-CBC').decrypt
      cipher.key = id_cipher_key
      binary = [enc_id].pack('H*')
      decrypted = cipher.update(binary) + cipher.final
      decrypted.force_encoding('UTF-8').to_i
    rescue OpenSSL::Cipher::CipherError
      nil
    end

    def self.find_by_encrypted_id!(enc_id)
      find(decrypt_id(enc_id))
    end

    def self.find_by_encrypted_id(enc_id)
      find_by(id: decrypt_id(enc_id))
    end

    def self.id_cipher_key
      Digest::SHA256.digest(
        [
          name,
          'id',
          Settings.activerecord_id_encrypted_encoded_key,
        ].join(':'),
      )
    end

    def encrypted_id
      self.class.encrypt_id(id)
    end
  end
end
