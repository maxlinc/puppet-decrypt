Feature: Puppet works

  Scenario: Default test
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

  Scenario: Overriden key (string)
    Given I have the following hiera data:
      """
      ---
        db_password: ENC:alt_key[c4S4hMCDv1b7FkZgOBRTOA==]
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
          value: 'ENC[G6MjBDDFcapYLaKBFJvPSg==]'
          secretkey: 'features/fixtures/other_secretkeys/secondary_key'
      """
    When I execute this puppet manifest:
      """
      notice(hiera_hash('db_password'))
      $password = decrypt(hiera_hash('db_password'))
      notice("Decrypted: $password")
      """
    Then the output should include "Decrypted: overridden"