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
    notice($password)
    """
  Then the output should include "Notice: Scope(Class[main]): max"