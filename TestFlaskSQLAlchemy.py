from flask import Flask, request, jsonify 
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///meubanco.db'

db = SQLAlchemy(app)

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    price = db.Column(db.Float, nullable=False)
    description = db.Column(db.Text, nullable=True)


with app.app_context():
    db.create_all()


@app.route('/api/products/add', methods=["POST"])
def add_product():
		#Obter os dados JSON da requisição
    data = request.json
    # Verificar se os campos 'name' e 'price' estão presentes nos dados
    if 'name' in data and 'price' in data: 
	    new_product = Product(
		    name=data["name"],
		    price=data["price"],
		    # Usa um valor padrão vazio se 'description' não estiver presente
		    description=data.get("description", ""))
		  # Adicionar o novo produto à sessão do banco de dados
	    db.session.add(new_product)
	    # Confirmar a transação para salvar o produto no banco de dados
	    db.session.commit()
	    #Retornar uma resposta JSON indicando que o produto foi cadastrado com sucesso
	    return jsonify({"message": "Produto cadastrado com sucesso"})
	  # Se os dados necessários não estiverem presentes, retornar uma resposta de erro
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

if __name__ == '__main__':
    app.run(debug=True)