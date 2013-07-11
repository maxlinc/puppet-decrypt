Around do | scenario, block |
  hierafile = Tempfile.new(['hierafile', '.yaml'], 'features/fixtures/data')
  Thread.current[:hierafile] = hierafile
  begin
    block.call
  ensure
    hierafile.close
    hierafile.unlink
  end
end
