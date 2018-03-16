import "dart:html";
import "../SBURBSim.dart";
import "SessionSummaryLib.dart";
import 'dart:convert';



class CarapaceStats {

    List<int> sessions = new List<int>();

    String aliases;
    String exampleName;
    String initials;
    String moon;
    String description;

    bool showingStats = true;

    Element statPage;
    Element descriptionPage;

    Map<String, int> statsMap = new Map<String, int>();

    CarapaceStats(Carapace carapace) {
        if(carapace != null) {
            loadCarapace(carapace);
        }else {
            initStats();
        }
    }

    void initStats() {
        this.initials = "???";
        this.exampleName = "???";
        this.aliases = "???";
        this.moon = "???";
        this.description = "???";
        statsMap["Times Activated"] = 0;
        statsMap["Times Crowned"] = 0;
        statsMap["Carapaces Murdered"]  = 0;
        statsMap["Times Joined Players"] = 0;
        statsMap["Moons Murdered"]  = 0;
        statsMap["Planets Murdered"]  = 0;
        statsMap["Red Miles Activated"]  = 0;
        statsMap["Players Murdered"]  = 0;
        statsMap["Times Died"]  = 0;
        statsMap["Times Exiled"] = 0;
    }

    void loadCarapace(Carapace carapace) {
        print("loading carapace $carapace who is active ${carapace.active}");
        this.initials = carapace.initials;
        this.exampleName = carapace.name;
        this.aliases = carapace.aliases;
        this.moon = carapace.type;
        this.description = carapace.description;
        statsMap["Times Activated"] = carapace.active ? 1 : 0;
        statsMap["Times Joined Players"] = carapace.partyLeader != null ? 1 : 0;
        statsMap["Times Crowned"] = carapace.everCrowned ? 1 : 0;
        statsMap["Carapaces Murdered"] = carapace.npcKillCount;
        statsMap["Moons Murdered"] = carapace.moonKillCount;
        statsMap["Planets Murdered"] = carapace.landKillCount;
        statsMap["Red Miles Activated"] =  carapace.usedMiles ? 1 : 0;
        statsMap["Players Murdered"] = carapace.playerKillCount;
        statsMap["Times Died"] =  carapace.dead ? 1 : 0;
        statsMap["Times Exiled"] =  carapace.exiled ? 1 : 0;
        sessions.add(carapace.session.session_id);
        print("loaded carapace $carapace who is active ${statsMap["Times Activated"]}");

    }

    void fromJSON(String jsonString) {
        print("trying to make a carapace summary from $jsonString");
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        for(String key in statsMap.keys) {
            // print("checking num key of $key with value ${json[key]}");
            statsMap[key] = num.parse(json[key]);
        }
        aliases = json["aliases"];
        exampleName = json["exampleName"];
        initials = json["initials"];
        moon = json["moon"];
        sessions  = new List.from(JSONObject.jsonStringToIntSet(json["sessions"]));
    }

    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        for(String key in statsMap.keys) {
            json[key] = statsMap[key].toString();
        }
        json["aliases"] = aliases;
        json["exampleName"] = exampleName;
        json["initials"] = initials;
        json["moon"] = moon;
        json["sessions"] = sessions.toString();

        return json;
    }

    //add all others vars to yourself
    void add(CarapaceStats other) {
        for(String key in statsMap.keys) {
            if(other.statsMap.containsKey(key))statsMap[key] += other.statsMap[key];
        }
        sessions.addAll(other.sessions);

    }

    Element makePortrait() {
        DivElement div = new DivElement();
        div.classes.add("cardPortraitBG");
        div.style.backgroundImage = "url(images/BigBadCards/$moon.png)";
        ImageElement portrait = new ImageElement(src: "images/BigBadCards/${initials.toLowerCase()}.png");
        portrait.classes.add("cardPortrait");

        div.append(portrait);

        return div;
    }

    Element makeDescription() {
        DivElement div = new DivElement();
        div.classes.add("cardStats");
        div.style.display = "none";
        div.text = description;
        descriptionPage = div;
        return div;

    }

    void togglePage() {
        if(showingStats) {
            statPage.style.display = "inline-block";
            descriptionPage.style.display = "none";

        }else {
            descriptionPage.style.display = "inline-block";
            statPage.style.display = "none";
        }
        showingStats = !showingStats;
    }

    Element makeStats() {
        DivElement div = new DivElement();
        div.classes.add("cardStats");
        for(String key in statsMap.keys) {
            DivElement tmp = new DivElement();
            tmp.classes.add("cardStatBox");
            SpanElement first = new SpanElement();
            first.setInnerHtml("${key}:");
            first.classes.add("cardStatName");

            SpanElement second = new SpanElement();
            second.classes.add("cardStatValue");
            second.setInnerHtml("${statsMap[key]}");
            tmp.append(first);
            tmp.append(second);
            div.append(tmp);
        }

        DivElement activeSession = new DivElement();
        activeSession.setInnerHtml("Sessions Active In: ...");
        activeSession.classes.add("tooltip");
        DivElement tooltipText  = new DivElement();
        tooltipText.classes.add("tooltiptext");
        activeSession.append(tooltipText);
        div.append(activeSession);
        for(int session_id in sessions) {
            DivElement d = new DivElement();
            AnchorElement a = new AnchorElement();
            a.href = "index2.html?seed=$session_id";
            a.text = " $session_id, ";
            d.append(a);
            tooltipText.append(d);
        }
        statPage = div;
        return div;
    }



    //display pic of prospit or derse.
    //display placeholder for the carpace in question.
    Element getCard() {
        DivElement div = new DivElement();
        div.onClick.listen((e)
        {
            togglePage();
        });
        div.classes.add("collectibleCard");

        DivElement divBorder = new DivElement();
        divBorder.classes.add("collectibleCardBorder");

        DivElement name = new DivElement();
        name.classes.add("cardName");
        name.text = "Name: $exampleName ($initials)";
        DivElement alts = new DivElement();
        alts.text = "Aliases: ...";
        alts.classes.add("tooltip");
        alts.style.display = "block";
        DivElement altText = new DivElement();
        altText.classes.add("tooltiptext");
        alts.append(altText);
        altText.text = aliases;
        name.append(alts);

        divBorder.append(div);
        div.append(makePortrait());
        div.append(name);
        div.append(makeStats());
        div.append(makeDescription());
        return divBorder;
    }

}

/*
    TODO: so how do i want this to work. This is a single object that ShogunBot has, but how does it get built?
    need to have an object LIKE this  for every SessionSummary maybe even still with CarapceStats...
    oh...could just literally use this, then also have a way to hrrrm....
 */
class CarapaceSummary {
    Map<String, CarapaceStats> data = new Map<String, CarapaceStats>();

    Session session;
    CarapaceSummary(Session this.session) {
        if(session == null) {
            defaultSession();
        }
        init();
    }
    void defaultSession() {
         session = new Session(-13);
         session.setupMoons();
    }


    void fromJSON(String jsonString) {
      //  print("trying to laod carapace summary from json");
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        List<dynamic> what = JSON.decode(json["data"]);
        for(dynamic d in what) {
            //print("dynamic json thing for carapace summary is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            //print("made a json object $j, going to make a carapace summary");
            CarapaceStats s = new CarapaceStats(null);
            //print("made a carapace summary, gonna load it from json");
            s.fromJSON(j.toString());
           // print("loaded that carapace summary to json");
            data[s.initials] = s;
        }

    }

    JSONObject toJSON() {
        JSONObject container  = new JSONObject();
        List<JSONObject> jsonArray = new List<JSONObject>();
        for(CarapaceStats cs in data.values) {
            jsonArray.add(cs.toJSON());
        }
        container["data"] = jsonArray.toString();
        return container;
    }

    //if you add a carapace summary to yourself, you add all it's values to your own data.
    void add(CarapaceSummary other) {
        for(CarapaceStats cs in other.data.values) {
            data[cs.initials].add(cs);
        }
    }

    void init() {

        List<GameEntity> npcs = session.activatedNPCS;
        //if moon is destroyed, all record of you is too. thems the breaks.
        //or....maybe i can keep a record. cuz it sure will look weird if jack kills more ppl than shogunbot thinks exist
        if(session.prospit != null) npcs.addAll(session.npcHandler.prospitians);

        npcs.add(session.battlefield.whiteKing);
        if(session.prospit != null) npcs.add(session.prospit.queen);
        if(session.derse != null) npcs.addAll(session.npcHandler.dersites);
        npcs.add(session.battlefield.blackKing);
        if(session.derse != null) npcs.add(session.derse.queen);


        for(GameEntity g in npcs) {
            if(g is Carapace) {
                CarapaceStats s = new CarapaceStats(g);
                data[s.initials] = s;
            }
        }
    }
}

