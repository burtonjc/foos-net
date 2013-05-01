define [
  'mongoose'

], (mongoose) ->
  trimAndLowerCase = (v) ->
    v.trim().toLowerCase()

  PlayerSchema = new mongoose.Schema
    name:
      type: String
      required: true
    email:
      type: String
      required: true
      unique: true
      set: trimAndLowerCase
    elo: Number

  mongoose.model 'Player', PlayerSchema
  mongoose.model 'Player'
