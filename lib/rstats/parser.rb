require 'uri'

module Rstats

  module Parser

    class UserAgent
      def self.get_platform(user_agent)
        platform = nil
        
        if user_agent =~ /Win/i
          platform = "Windows"
        elsif user_agent =~ /Mac/i
          platform = "Macintosh"
        elsif user_agent =~ /Linux/i
          platform = "Linux";
        elsif user_agent =~ /SunOS/i
          platform = "Sun Solaris";
        elsif user_agent =~ /BSD/i
          platform = "FreeBSD";
        else
          platform = "Other"
        end
        return platform
      end

      def self.browser_info(user_agent)
        browser = {
          :type => nil,
          :version => nil
        }
        #Internet Exlorer
        if user_agent =~ /MSIE/i && user_agent.scan(/AOL|America Online Browser/i).empty?
          browser[:type] = "MSIE";
          browser[:version] = user_agent.scan(/MSIE ([\d\.]+)/i).to_s
          #Firefox/Firebird/Phoenix
        elsif user_agent =~ /Firefox|Firebird|Phoenix/i
          browser[:type] = "Firefox";
          browser[:version] = user_agent.scan(/[Firefox|Firebird|Phoenix].\/(\d.+)/i).to_s
          #Galeon
        elsif user_agent =~ /Galeon/i
          browser[:type] = "Galeon";
          browser[:version] = user_agent.scan(/Galeon\/([\d\.]+)/i).to_s
          #Safari
        elsif user_agent =~ /Safari/i
          browser[:type] = "Safari";
          browser[:version] = nil
          #Opera
        elsif user_agent =~ /Opera/i
          browser[:type] = "Opera";
          browser[:version] = user_agent.scan(/Opera[ |\/]([\d\.]+)/i).to_s
          #AOL/America Online Browser
        elsif user_agent =~ /AOL|America Online Browser/i
          browser[:type] = "AOL"
          browser[:version] = if user_agent =~ /AOL/i
            user_agent.scan(/AOL[ |\/]([\d.]+)/i).uniq.to_s
          else
            user_agent.scan(/America Online Browser ([\d\.]+)/i).to_s
          end
          #Camino
        elsif user_agent =~ /Camino/i
          browser[:type] = "Camino";
          browser[:version] = user_agent.scan(/Camino\/([\d\.]+)/i).to_s
          #Konqueror
        elsif user_agent =~ /Konqueror/i
          browser[:type] = "Konqueror";
          browser[:version] = user_agent.scan(/Konqueror\/([\d.]+)/i).to_s
          #K-Meleon
        elsif user_agent =~ /K-Meleon/i
          browser[:type] = "K-Meleon";
          browser[:version] = user_agent.scan(/K-Meleon\/([\d.]+)/i).to_s
          #Firefox BonEcho
        elsif user_agent =~ /BonEcho/i
          browser[:type] = "Firefox BonEcho";
          browser[:version] = user_agent.scan(/BonEcho\/([\d.]+)/i).to_s
          #Netscape
        elsif user_agent =~ /Netscape/i
          browser[:type] = "Netscape";
          browser[:version] = user_agent.scan(/Netscape\/([\d.]+)/i).to_s
          #PSP
        elsif user_agent =~ /PlayStation Portable/i
          browser[:type] = "PlayStation Portable (PSP)";
          browser[:version] = user_agent.scan(/PlayStation Portable\); ([\d\.]+)/i).to_s
          #PlayStation 3
        elsif user_agent =~ /PlayStation 3/i
          browser[:type] = "PlayStation 3";
          browser[:version] = user_agent.scan(/PlayStation 3; ([\d\.]+)/i).to_s
          #Lynx
        elsif user_agent =~ /Lynx/i
          browser[:type] = "Lynx";
          browser[:version] = user_agent.scan(/Lynx\/([\d\.]+)/i).to_s
        else
          browser[:type] = "Other";
          browser[:version] = nil
        end
        return browser
      end
    end

    class Keyword
      def self.get_terms(string)
        return if string.nil?
        begin
          search_string = nil
          domain = URI::split(string)[2]
          if domain =~ /[google|alltheweb|search\.msn|ask|altavista|]\./ && string =~ /[?|&]q=/i
            search_string = CGI.unescape(string.scan(/[?|&]q=([^&]*)/).flatten.to_s)
          elsif domain =~ /yahoo\./i && string =~ /[?|&]p=/i
            search_string = CGI.unescape(string.scan(/[?|&]p=([^&]*)/).flatten.to_s)
          elsif domain =~ /search\.aol\./i && string =~ /[?|&]query=/i
            search_string = CGI.unescape(string.scan(/[?|&]query=([^&]*)/).flatten.to_s)
          end
          return search_string          
        rescue
          return nil
        end    
      end

      def self.get_referer(string, host)
        return if string.nil?
        domain = nil
        domain = URI::split(string)[2]
        return domain != host ? domain : nil
      end
    end

    class Robot
      def self.get_name(agent)
        robot = nil
        if agent =~ /Atomz/i
          robot = 'Atomz.com'
        elsif agent =~ /Googlebot/i
          robot = 'Googlebot'
        elsif agent =~ /InfoSeek/i
          robot = 'InfoSeek'
        elsif agent =~ /Ask Jeeves/i
          robot = 'Ask Jeeves'
        elsif agent =~ /Lycos/i
          robot = 'Lycos'
        elsif agent =~ /MSNBOT/i
          robot = 'MSNBot'
        elsif agent =~ /Slurp/i && agent.scan(/Yahoo/i).empty?
          robot = 'Inktomi'
        elsif agent =~ /Yahoo/i
          robot = 'Yahoo Slurp'
        end
        return robot
      end      
    end

    class Language
      def self.get_name(lang)
        lang = lang.scan(/([^,;].*)/).to_s
        lang = lang.slice(0,5)
        languages = {
          "af"    => "Afrikaans",
          "sq"    => "Albanian",
          "eu"    => "Basque",
          "bg"    => "Bulgarian",
          "be"    => "Byelorussian",
          "ca"    => "Catalan",
          "zh"    => "Chinese",
          "zh-cn" => "Chinese/China",
          "zh-tw" => "Chinese/Taiwan",
          "zh-hk" => "Chinese/Hong Kong",
          "zh-sg" => "Chinese/singapore",
          "hr"    => "Croatian",
          "cs"    => "Czech",
          "da"    => "Danish",
          "nl"    => "Dutch",
          "nl-nl" => "Dutch/Netherlands",
          "nl-be" => "Dutch/Belgium",
          "en"    => "English",
          "en-gb" => "English/United Kingdom",
          "en-us" => "English/United States",
          "en-au" => "English/Australian",
          "en-ca" => "English/Canada",
          "en-nz" => "English/New Zealand",
          "en-ie" => "English/Ireland",
          "en-za" => "English/South Africa",
          "en-jm" => "English/Jamaica",
          "en-bz" => "English/Belize",
          "en-tt" => "English/Trinidad",
          "et"    => "Estonian",
          "fo"    => "Faeroese",
          "fa"    => "Farsi",
          "fi"    => "Finnish",
          "fr"    => "French",
          "fr-be" => "French/Belgium",
          "fr-fr" => "French/France",
          "fr,fr" => "French/France",
          "fr-ch" => "French/Switzerland",
          "fr-ca" => "French/Canada",
          "fr-lu" => "French/Luxembourg",
          "gd"    => "Gaelic",
          "gl"    => "Galician",
          "de"    => "German",
          "de-at" => "German/Austria",
          "de-de" => "German/Germany",
          "de-ch" => "German/Switzerland",
          "de-lu" => "German/Luxembourg",
          "de-li" => "German/Liechtenstein",
          "el"    => "Greek",
          "he"    => "Hebrew",
          "he-il" => "Hebrew/Israel",
          "hi"    => "Hindi",
          "hu"    => "Hungarian",
          "ie-ee" => "Internet Explorer/Easter Egg",
          "is"    => "Icelandic",
          "id"    => "Indonesian",
          "in"    => "Indonesian",
          "ga"    => "Irish",
          "it"    => "Italian",
          "it-ch" => "Italian/ Switzerland",
          "ja"    => "Japanese",
          "ko"    => "Korean",
          "lv"    => "Latvian",
          "lt"    => "Lithuanian",
          "mk"    => "Macedonian",
          "ms"    => "Malaysian",
          "mt"    => "Maltese",
          "no"    => "Norwegian",
          "pl"    => "Polish",
          "pt-pt" => "Portuguese",
          "pt-br" => "Portuguese/Brazil",
          "rm"    => "Rhaeto-Romanic",
          "ro"    => "Romanian",
          "ro-mo" => "Romanian/Moldavia",
          "ru-ru" => "Russian",
          "ru-mo" => "Russian /Moldavia",
          "gd"    => "Scots Gaelic",
          "sr"    => "Serbian",
          "sk"    => "Slovack",
          "sl"    => "Slovenian",
          "sb"    => "Sorbian",
          "es"    => "Spanish",
          "es-do" => "Spanish",
          "es-ar" => "Spanish/Argentina",
          "es-co" => "Spanish/Colombia",
          "es-mx" => "Spanish/Mexico",
          "es-es" => "Spanish/Spain",
          "es-gt" => "Spanish/Guatemala",
          "es-cr" => "Spanish/Costa Rica",
          "es-pa" => "Spanish/Panama",
          "es-ve" => "Spanish/Venezuela",
          "es-pe" => "Spanish/Peru",
          "es-ec" => "Spanish/Ecuador",
          "es-cl" => "Spanish/Chile",
          "es-uy" => "Spanish/Uruguay",
          "es-py" => "Spanish/Paraguay",
          "es-bo" => "Spanish/Bolivia",
          "es-sv" => "Spanish/El salvador",
          "es-hn" => "Spanish/Honduras",
          "es-ni" => "Spanish/Nicaragua",
          "es-pr" => "Spanish/Puerto Rico",
          "sx"    => "Sutu",
          "sv"    => "Swedish",
          "sv-se" => "Swedish/Sweden",
          "sv-fi" => "Swedish/Finland",
          "ts"    => "Thai",
          "tn"    => "Tswana",
          "tr"    => "Turkish",
          "uk"    => "Ukrainian",
          "ur"    => "Urdu",
          "vi"    => "Vietnamese",
          "xh"    => "Xshosa",
          "ji"    => "Yiddish",
          "zu"    => "Zulu"}
          return languages.fetch(lang, lang) 
        end
      end

    end

  end