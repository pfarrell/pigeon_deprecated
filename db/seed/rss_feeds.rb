require './app'
def add_color(id, color)
  feed = Source[id]
  feed.color=color
  feed.save
end

add_color(1, 'F1E4E8')
