define [
  'db/mongo'
  'models/player'
  'Faker'
], (mongo, Player, Faker) ->
  describe "The Player model", ->
    before (done) ->
      mongo.init done

    after (done) ->
      mongo.shutdown done

    it "lowercases email addresses when they are set", (done) ->
      player = new Player(
        name: Faker.Name.findName()
        elo: 1100
      )
      email = Faker.Internet.email().toUpperCase()
      player.set 'email', email
      player.get('email').should.equal email.toLowerCase()

      player.save (err, product) ->
        expect(err).not.to.exist
        product.get('email').should.equal email.toLowerCase()

        Player.findById player, (err, doc) ->
          expect(err).not.to.exist
          doc.get('email').should.equal email.toLowerCase()
          done()
