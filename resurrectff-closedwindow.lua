json = require('dkjson')

function main(max_depth)
  print('Reading file...')
  local session = assert(io.open('sessionstore.js', 'r'))
  local session_data = session:read('*all')
  print('Parsing ('..#session_data..' bytes)...')
  local obj, pos, err = json.decode(session_data, 1, json.null)
  if err then error(err) end

  print('Success! table size: '..#obj, pos, err)

  -- swap open/closed windows
  print('Decoded, swapping closed and open windows')
  local old_windows = obj.windows
  obj.windows = obj._closedWindows
  obj._closedWindows = old_windows

  print('Encoding')
  local outf = assert(io.open('sessionstore-rec-fixed.js', 'w'))
  outf:write(json.encode(obj))
  outf:close()
  return obj
end

main()

