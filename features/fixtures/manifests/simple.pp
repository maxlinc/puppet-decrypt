$decrypted = decrypt(hiera('db_password'))
notice($decrypted)
$expected = 'blablabla'
unless($decrypted == $expected) {
  fail("Expected '$expected', found $unexpected")
}