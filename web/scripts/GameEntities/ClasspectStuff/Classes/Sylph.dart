import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Sylph extends SBURBClass {
    @override
    List<String> levels = ["SERENE SCALLYWAG", "MYSTICAL RUGMUFFIN", "FAE FLEDGLING"];
    @override
    List<String> quests = ["restoring a consort city to its former glory", "preserving the legacy of a doomed people", "providing psychological counseling to homeless consorts"];
    @override
    List<String> postDenizenQuests = ["beginning to heal the vast psychological damage their consorts have endured from the denizen’s ravages", "setting up counseling booths around their land and staffing them with well trained consort professionals", "bugging and fussing and meddling with the consorts, but now using their NEW FOUND POWERS", "realizing that maybe their bugging and fussing and meddling isn’t always the best way to deal with things"];
    @override
    List<String> handles = ["serious", "surly", "sour", "sweet", "stylish", "soaring", "serene", "salacious"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = true;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.1, false)
    ]);

    Sylph() : super("Sylph", 5, true);


    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * 0.5;
        } else {
            powerBoost = powerBoost * -0.5;
        }
        return powerBoost;
    }

    @override
    double getAttackerModifier() {
        return 1.0;
    }

    @override
    double getDefenderModifier() {
        return 1.0;
    }

    @override
    double getMurderousModifier() {
        return 1.5;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be feeling more helpful after being around the ${target.htmlTitle()}. ";
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = 2 * p.getPowerForEffects() / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //modify other.
        target.modifyAssociatedStat(powerBoost, stat);
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        //seers are blind, get it?
        addTheme(new Theme(<String>["Springs","Water", "Pools", "Reflection","Contemplation","Fountains","Wellsprings","Geysers"])
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.AXOLOTLCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ALLIGATORCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SALAMANDERCONSORT, Feature.MEDIUM)
            ..addFeature(new PostDenizenQuestChain("Purify the Water", [
                new Quest("The defeat of the ${Quest.DENIZEN} has some unforseen consequences, including the tainting of the water for the majority of the land. The ${Quest.CONSORT}s seem to have figured out a solution in the short term, but the ${Quest.PLAYER1} resolves to bug and fuss and meddle until things are fixed the right way. "),
                new Quest("So far, the ${Quest.PLAYER1} hasn't had much luck getting ${Quest.CONSORT}s to build a water purifying facility.  They are content just boiling their water. 'It's not hard', they say. It's so frustrating that the ${Quest.PLAYER1} knows they can help them but the ${Quest.CONSORT}s just will NOT cooperate. "),
                new Quest("The ${Quest.PLAYER1} has finally accepted that some people just don't want to be helped. As they make peace with this, a mysterious glow emerges from their chest.  The water of the land matches this glow, and the water is purified through the power of ${Quest.MCGUFFIN}. Huh. Okay then.")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}