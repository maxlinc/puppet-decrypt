Feature: Puppet works

Scenario: Simple test
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

  Scenario: Overridden key
  Given I have the following hiera data:
    """
    ---
      db_password:
        value: 'ENC[G6MjBDDFcapYLaKBFJvPSg==]'
        secretkey: 'features/fixtures/secretkeys/secondary_key'
    """
  When I execute this puppet manifest:
    """
    notice(hiera_hash('db_password'))
    $password = decrypt(hiera_hash('db_password'))
    notice("Decrypted: $password")
    """
  Then the output should include "Decrypted: overridden"