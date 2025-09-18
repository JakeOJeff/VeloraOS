local console = {}


function console:load()
    self.currentLine = 1
    self.lines = {
        content = {
            
        }
    }

end


function console:update(dt)



end

function console:textinput(t)
    
    table.insert(self.content, t)

end


function console:draw()


end

return console