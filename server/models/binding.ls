require! {
  Sequelize: sequelize
  '../config/sequelize'
}

module.exports = sequelize.define 'Binding' do
  clientId:
    type: Sequelize.STRING
    null: false
  albumId:
    type: Sequelize.STRING
    null: false
  albumDeleteHash:
    type: Sequelize.STRING
    null: false
  token:
    type: Sequelize.STRING
    null: false
  userEmail:
    type: Sequelize.STRING
    null: false
