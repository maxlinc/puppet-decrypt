Feature: Puppet works

  Scenario: Unsalted (legacy) key
    Given I have the following hiera data:
      """
      ---
        db_password: ENC[wx0qTorBqPrTrgkbzYirlA==]
      """
    When I execute this puppet manifest:
      """
      $password = decrypt(hiera('db_password'))
      notice("Decrypted: $password")
      """
    Then the output should include "Decrypted: max"

  Scenario: Default test
    Given I have the following hiera data:
      """
      ---
        db_password: ENC[HOz0/aHCjJTAUlEbM/pqMQ==:QZy2oTvQNhwFMmOARn+Jlw==:aUY1NjBqamp6RWs1UkYvVjVULzNvdz09]
      """
    When I execute this puppet manifest:
      """
      $password = decrypt(hiera('db_password'))
      notice("Decrypted: $password")
      """
    Then the output should include "Decrypted: max"

  Scenario: Overriden key (string)
    Given I have the following hiera data:
      """
      ---
        db_password: ENC:alt_key[KgLJnDVF9VeTGGU/vG2KjQ==:NiLhgUn4JL07DI9trGSK8g==:YlVhZDhDSEZsSDV6RnBOdm1FMmVtQT09]
      """
    When I execute this puppet manifest:
      """
      $password = decrypt(hiera('db_password'))
      notice("Decrypted: $password")
      """
    Then the output should include "Decrypted: abc123"

  Scenario: Overridden key (hash)
    Given I have the following hiera data:
      """
      ---
        db_password:
          value: 'ENC[AVdi08NXUveKStMSAH4kMQ==:EAHeMe3TvK33gjnDDHV5rQ==:cndoVVBhMWdXQW5HVSsxWDN4OUtRZz09]'
          secretkey: 'features/fixtures/other_secretkeys/secondary_key'
      """
    When I execute this puppet manifest:
      """
      notice(hiera_hash('db_password'))
      $password = decrypt(hiera_hash('db_password'))
      notice("Decrypted: $password")
      """
    Then the output should include "Decrypted: overridden"
