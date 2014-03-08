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
        db_password: ENC[9G9csZzrye5zELrUlxkD2g==:1234567890]
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
        db_password: ENC:alt_key[TQAbFNVPuH82z2tVHWXuB0jYy7YhLzQGiYlqkL8TClc=:1234567890]
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
          value: 'ENC[IRJVl4MV9APWGaKVnCMFKFVIjPbSYegX+TKwZ69FzZg=:1234567890]'
          secretkey: 'features/fixtures/other_secretkeys/secondary_key'
      """
    When I execute this puppet manifest:
      """
      notice(hiera_hash('db_password'))
      $password = decrypt(hiera_hash('db_password'))
      notice("Decrypted: $password")
      """
    Then the output should include "Decrypted: overridden"
