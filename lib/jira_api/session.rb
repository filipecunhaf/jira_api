
require_relative 'error'
require 'curb'

class JiraAPI

  # This class should be used to get an access token
  # for use with the main client class.
  class Session
    attr_accessor :user, :token

    @user = @token = @@cookie = @@has_session = nil

    def self.create( args={} )
      begin
        # URI.page( jira_base_uri )
        raise JiraAPI::Error.new( "Ivalid authentication method." ) unless ["gssapi","user_pass"].include?( args[:auth_method] )
        @@headers = {
          "User-Agent" => "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:55.0) Gecko/20100101 Firefox/55.0"
        }

        case args[:auth_method]
          when "user_pass"
            self.login_pass( args.slice(  :username, :password ) )
          when "gssapi"
            # Negotiate/Kerberos
            self.login_gssapi( args[:uri] ) #if auth_method == "gssapi"
          else
            raise JiraAPI::Error.new( "Ivalid auth method." )
        end
        
        raise JiraAPI::Error.new( "Unable to authenticate." ) unless @@has_session == true
        return self.new( @@cookie )
      rescue JiraAPI::Error => e
        raise e
      else
        true
      end
    end
    
    def self.destroy
      JiraAPI::Request.delete("/rest/auth/1/session")
    end

    def initialize( token )
      @token = token
    end

    def self.user
      @user
    end

    def self.token
      @token
    end

    def self.valid?
      begin
        resp = JiraAPI::Request.get("/rest/auth/1/session")
        if resp.status == 200
          @@has_session = true
          @user = Oj.load(resp.body)["name"]
        end
        raise JiraAPI::Error, "#{resp.body}" if resp.status != 200
      rescue JiraAPI::Error => err
        false
      else
        true
      end
    end

    private 

    def self.login_pass( args )

      begin
        required = [ :username, :password]

        raise JiraAPI::Error.new( "Invalid parameters." ) unless (args.keys - required).empty?
        
        params = {
          "username": args[:username],
          "password": args[:password]
        }
  
        resp = JiraAPI::Request.post("/rest/auth/1/session", params)
  
        if resp.status == 200
          @@has_session = true
          @@cookie = Oj.load(resp.body)["session"]["value"]
          @user = args[:username]
        end
        
      rescue Exception => err
        raise err 
      else
        true
      end

    end


    def self.login_gssapi( jira_base_uri=nil )
      begin         
        #puts "#{__method__}"
        def self.get_cookie(client=nil)
          # first request to get a new cookie
          client.get
          #puts client.header_str.inspect
          #puts client.header_str.match(%r{HTTP/.{3} 200})
          client.header_str.match(%r{set-cookie:\s\w+=(\w{0,32});}i)
          #puts "! 1 !"
          @@cookie = $1 unless $1.nil?
        end
        client = Curl::Easy.new
        client.headers = @@headers
        # client.proxy_url = 'http://127.0.0.1:8080'  
        client.ssl_verify_peer = false
        client.verbose = false
        client.enable_cookies = true
        client.http_auth_types = :gssnegotiate
        # The curl man page (http://curl.haxx.se/docs/manpage.html) says that
        # you have to specify a fake username when using Negotiate auth, and
        # they use ':' in their example.
        client.username = ':'
        client.url="#{jira_base_uri}/login.jsp"

        self.get_cookie(client) if @@cookie.nil?
        #puts "Before   ---"
        #puts client.header_str.inspect
        client.cookies = "JSESSIONID=#{@@cookie}"
       
        client.get

        # client.header_str.match(%r{X-Seraph-LoginReason:\s(OK)}i)
        #puts client.header_str.match(%r{HTTP/.{3} 200})
        unless client.header_str.match(%r{WWW-Authenticate:\sNegotiate}i)
        # if ( client.header_str.match(%r{HTTP/.{3} 200}) && client.header_str.match(%r{X-ASESSIONID:\s\w{6,7}}i) )
          # @@has_session = ($1.nil? == false)
          @@has_session = true
        end

      rescue Exception => err
        raise err   
      ensure
        client.reset
        client.close   
      end   
    end

  end

end