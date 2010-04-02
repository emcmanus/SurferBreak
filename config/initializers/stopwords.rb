module StopWords
  class English
    
    cattr_reader :all
    
    def self.init
      @@all = %w{a able about above according accordingly across actually after afterwards again against ago ahead 
        ain all almost alone along alongside already also although always am amid amidst among 
        amongst an and another any anybody anyhow anyone anything anyway anyways anywhere apart 
        are aren around as aside at b back be became because become becomes becoming been begin beginning before beforehand 
        behind being below beside besides best better between beyond both brief but by c can cannot 
        cant cause causes certainly could couldn d definitely despite did didn do does doesn doing 
        done don during e each edition either else elsewhere enough et etc even ever evermore every everybody 
        everyone everything everywhere ex exactly except f fairly far farther few fewer followed following follows for
        former formerly forth forward found from further furthermore g got gotten h 
        had hadn half hardly has hasn have haven having he  hence her here hereafter hereby herein 
        hereupon hers herself hi him himself his hopefully how 
        howbeit however hundred i ie if ignored immediate in inasmuch indeed inner inside insofar instead into 
        inward is isn it its itself j just k l ll last lately later latter latterly 
        least less lest let like liked likely likewise little m mainly  
        many may maybe mayn me mean meantime meanwhile merely might mightn mine more moreover 
        most mostly mr mrs much must mustn my myself n name namely nd near nearly necessary need needn needs neither 
        never neverf neverless nevertheless new next nine ninety no nobody non none nonetheless noone nor 
        not nothing notwithstanding now nowhere o obviously of off often oh ok okay on
        one ones only onto or other others otherwise ought oughtn our ours ourselves out outside over 
        overall own p particular particularly past per perhaps please plus presumably probably 
        provided provides q que quite qv r rather rd re really reasonably recent recently regarding regardless 
        regards relatively respectively right round s said same saw say saying says see seeing 
        seem seemed seeming seems seen self selves sensible sent series serious seriously several shall shan she 
        should shouldn since so some somebody someday somehow someone something sometime sometimes somewhat 
        somewhere soon sorry still sub such sup sure t th than thank thanks thanx that thats the their theirs 
        them themselves then thence there thereafter thereby therefore therein theres thereupon these they thing 
        things this thorough thoroughly those though through throughout thru thus till to together too took toward 
        towards truly u un under underneath undoing unfortunately unless unlike unlikely until unto upon 
        us use used useful uses using usually v various vversus ve very via viz vs w want wants was 
        wasn way we well went were what whatever when whence whenever where whereafter whereas whereby 
        wherein whereupon wherever whether which whichever while whilst whither who whoever whole whom whomever whose 
        why will willing with within without won would wouldn x y yes yet you your yours yourself 
        yourselves z}
    end
  end
end

StopWords::English.init
