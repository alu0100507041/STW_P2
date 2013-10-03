require 'rack/request'
require 'twitter'
require './configure'

class Twitts 
 def call env
    req = Rack::Request.new(env)
    res = Rack::Response.new
    binding.pry if ARGV[0]
    res['Content-Type'] = 'text/html'
    name = (req["firstname"] != '') ? req["firstname"] :'RafaelNadal' #Nombre del usuario
    ntwitts = (req["ntw"]&& req["ntw"].to_i>1 !='') ? req["ntw"].to_i : 3 #Numero de Twitts

    usuario = Twitter.user(name) #Obtener el nombre del nombre del usuario
    twitt = Twitter.user_timeline(name)[0..ntwitts.to_i] #Obtener los twitts

    res.write <<-"EOS"
       <!DOCTYPE HTML>
          <html>
             <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
             </head>
             <title>Practica Rack</title>
             <body>
                <h1>Practica: Accediendo a Twitter y mostrando los ultimos twitts en una pagina</h1>
                <h3>Sistemas y Tecnologias Web </h3>
                <form action="/" method="post">
                   <p>Nombre del usuario:<input type="text" name="firstname" autofocus></p>
                   <p>Numero de Twitts:<input type ="text" name="ntw" ></p>
	           <input type="submit" value="Aceptar">
                </form>
                <br>
                <br>
                <strong> Nombre del usuario: #{usuario.name} 
                Numero de twitts: #{ntwitts} </strong>
                EOS
                for t in twitt
                   res.write <<-"HERE"
                   <ol>
	              <p>Twitts: #{t.text} </p>
                   </ol>
             </body>
          </html>
          HERE
        end
     res.finish
  end
end

if $0 == __FILE__
  require 'rack'
  Rack::Server.start(
    :app => Twitts.new, 
    :Port => 9292,
    :server => 'thin'
  )
end
