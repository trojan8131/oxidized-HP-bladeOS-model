class Blade < Oxidized::Model
# Stare HP Blade :(
  prompt /^>>.+\#\s/
  comment  '/* '
  cmd '/info/sys/general' do |c|
    c = c.each_line.reject { |line| line.match /(.*System\sInformation.*)|(.*Switch\shas.*)/ }
    c = c.join
    comment c
  end
  cmd '/info/link' do |c|
     comment c
  end
  cmd '/info/port' do |c|
     comment c
  end
  comment  ''
  cmd '/cfg/dump' do |c|
     c = c.each_line.reject { |line| line.match /(.*Configuration\sdump.*)|(.*admpw.*)|(.*esecret.*)/ }
     c = c.join
     c
  end
  comment  '/* '
  cmd '/info/sys/chassis' do |c|
     comment c
  end
  cmd '/boot/cur' do |c|
     comment c
  end

  # cleanup function, pager can't be turned off ;/
  cmd :all do |data|
    out = ""
    data.split("\n").each do |data|
        if data !~ /.*\x27.*/ && data !~ /^.*\x08\x20\x08.*/
            out = out + data + "\n"
            data = ""
        else
            data.gsub!(/.*\x08/,'')
            data.gsub!(/.*\x27/,'')
            out = out + data + "\n"
        end
    end
    out
  end

  expect /.*Press q to quit, any other key to continue*/ do |data, re|
      send ' '
      data.sub re, ''
  end

  cfg :ssh do
    password /^.+password:\s$/
    pre_logout 'exit'
  end

end
