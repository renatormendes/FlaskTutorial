from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask import Flask, request, jsonify

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///ecomerce.sqlite'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Product(db.Model):

	id = db.Column(db.Integer, primary_key = True)
	name = db.Column(db.String(80), nullable = False)
	price = db.Column(db.Float, nullable = False)
	description = db.Column(db.Text, nullable = True)

with app.app_context():

	db.create_all()

@app.route('/api/products/add', methods=["POST"])

def add_product():

    data = request.json

    if 'name' in data and 'price' in data:

		    new_product = Product(
			    name=data["name"],
			    price=data["price"], 
			    description=data.get("description", ""))
		    db.session.add(new_product)
		    db.session.commit()
		    return jsonify({"message": "Produto cadastrado com sucesso"})

    return jsonify({"message": "Dados do produto inválido!"}), 400

@app.route('/api/products/delete/<int:product_id>')

def delete_product(product_id):

		#Recuperar o produto da base de dados
		product = Product.query.get(product_id)
		#Verificar se o produto existe ou não 
		if product:

		#Se existe, apagar da base de dados
				db.session.delete(product)
				db.session.commit()
				return jsonify({"message": "Produto deletado com sucesso"})

		#Se não existe, retornar 404 not found
		return jsonify({"message": "Produto não encontrado"}), 404

							