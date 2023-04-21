from flask import *
from paper import check_validation
from web3 import Web3
from eth_account import Account
from plag_content import give_plag_content


app = Flask(__name__,template_folder="template")
ganache_url='http://127.0.0.1:7545'
web3=Web3(Web3.HTTPProvider(ganache_url))


@app.route('/')
def home():
	return render_template('login.html',error="")

@app.route('/welcome',methods=['POST','GET'])
def welcome():
		if request.method == 'POST':
			sender=request.form['sender']
			passkey=request.form['passkey']
			file=request.form['file']
			global web3
			ether=web3.eth.get_balance(sender)
			ether=web3.from_wei(ether,'ether')
			if len(file)==0:
				error='Please submit a valid file'
				plagarised_content="Can not load file data"
			else:
				val=check_validation(file,sender)
				if(len(val)==4):
					ether=val[0]
					error=f"The Document was successfully published [Plagarism: {val[2]}%]"
					plag_list=val[3]	
				else:
					ether=val[0]
					error=f"There was {val[1]}% plagarism found in the documents"
					plag_list=val[2]
				plagarised_content=give_plag_content(file,plag_list)
	
		else:
			error="Something went wrong"
			ether=0
			plagarised_content="Can not load file data"
		ether=round(ether,6)
		return  render_template('welcome.html',sender=sender,passkey=passkey,error=error,ether=ether,plagarised_content=plagarised_content)

@app.route('/login', methods=['POST', 'GET'])
def login():
	if request.method == 'POST':
		# sender = request.form['address']
		passkey=request.form['passkey']
		error=''
		global web3
		try:
			account = Account.from_key(passkey)
			sender=account.address
			ether=web3.eth.get_balance(sender)
			ether=web3.from_wei(ether,'ether')
			ether=round(ether,6)
			return render_template('welcome.html',sender=sender,passkey=passkey,error=error,ether=ether,plagarised_content="<i> File not available </i>")
		except:
			error="Your passkey is not valid"
			return render_template('login.html',error=error)
		
	else:
		error="Something Went Wrong"
		return render_template('login.html',error=error)




if __name__ == '__main__':
	app.run(debug=True,port=9999)


# PDF
# Graph
# Sentence