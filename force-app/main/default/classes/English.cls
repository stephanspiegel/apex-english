/**
* @description Utility class for handling text fragments with dynamic numbers, where nouns or verbs need
*       to be pluralized accordingly
*/
public with sharing class English {

    /**
    * @description Interface to represent a word that can be either singular or plural
    */
    public interface PluralizeAble {
        /**
        * @description The singular variant of the word
        */
        String getSingular();
        /**
        * @description The plural variant of the word
        */
        String getPlural();
    }

    /**
    * @description Internal class to represent verbs
    */
    public class Verb implements PluralizeAble {
        private String singular;
        private String plural;
        public String getSingular(){
            return singular;
        }
        /**
        * @description The plural variant of the word. For verbs, assume plural is singular minus the 's'
        */
        public String getPlural() {
            return plural == null ? singular.removeEnd('s') : plural;
        }
        /**
        * @description Constructor for specifying singular variant only
        *
          * @param singular The singular variant of the word
        *
        */
        public Verb(String singular){ 
            this.singular = singular; 
        }
        /**
        * @description Constructor for specifying singular and plural variants
        *
          * @param singular The singular variant of the word
          * @param plural The plural variant of the word
        *
        */
        public Verb(String singular, String plural){ 
            this.singular = singular; 
            this.plural = plural; 
        }
    }

    /**
    * @description Internal class to represent nouns
    */
    public class Noun implements PluralizeAble {

        private String singular;
        private String plural;
        /**
        * @description The plural variant of the word. For nouns, assume it's singular + 's' if not specified.
        */
        public String getPlural() {
            return plural == null ? singular + 's' : plural;
        }
        public String getSingular() {
            return singular;
        }
        /**
        * @description Constructor for specifying singular variant only
        *
          * @param singular The singular variant of the word
        *
        */
        public Noun(String singular){ 
            this.singular = singular; 
        }

        /**
        * @description Constructor for specifying singular and plural variants
        *
          * @param singular The singular variant of the word
          * @param plural The plural variant of the word
        *
        */
        public Noun(String singular, String plural){
            this.singular = singular; 
            this.plural = plural;
        }
    }


    private static final Map<Integer, String> NUMBER_TO_ENGLISH = new Map<Integer, String>{
        0 => 'no',
        1 => 'one',
        2 => 'two',
        3 => 'three',
        4 => 'four',
        5 => 'five',
        6 => 'six',
        7 => 'seven',
        8 => 'eight',
        9 => 'nine',
        10 => 'ten',
        11 => 'eleven',
        12 => 'twelve'
    };
    private static final String STANDARD_FORMAT = '{!number} {!noun}';

    private static String pluralizeNoun(Integer numberOfThings, Noun noun){
        return isPlural(numberOfThings) ? noun.getPlural() : noun.getSingular();
    }

    private static Boolean isPlural(Integer numberOfThings){
        return numberOfThings != 1;
    }

    /**
    * @description Return singular or plural version of a noun, based on number. This variant accepts a string
    *       and assumes that the noun has a regular plural version (ie. singular + 's')
    *
      * @param  numberOfThings  The number which will determine if we use plural or singular
      * @param  nameOfThing The noun for which we will return singular or plural
    *   
      * @return The noun in its singular or plural form, depending on the value of numberOfThings
    */
    public static String pluralize(Integer numberOfThings, String nameOfThing) {
        return pluralizeFormat(STANDARD_FORMAT, numberOfThings, new Noun(nameOfThing));
    }

    /**
    * @description Return singular or plural version of a noun, based on number. This variant accepts a Noun
    *       object, allowing for irregular plural (ie. "child", "children")
    *
      * @param  numberOfThings  The number which will determine if we use plural or singular
      * @param  noun The noun for which we will return singular or plural
    *   
      * @return The noun in its singular or plural form, depending on the value of numberOfThings
    */
    public static String pluralize(Integer numberOfThings, Noun noun){
        return pluralizeFormat(STANDARD_FORMAT, numberOfThings, noun);
    }

    /**
    * @description Return a string containing a singular or plural version of a noun, based on number, and the number,
    * using string substitution. 
    * Examples:
    * pluralizeFormat('Found {!number} eligible {!noun}', 2, 'Rebate') returns 'Found two eligible Rebates'
    * pluralizeFormat('{!number} {!noun} found', 1, 'Rebate') returns 'one Rebate found'
    *
      * @param  format  Format string used to generate final string. Mark the place for the number with {!number}
      *         and the place for the noun with {!noun}
      * @param  numberOfThings  The number which will determine if we use plural or singular
      * @param  nameOfThing The noun, which will be used in singular or plural form
    *   
      * @return The format string, with the number and pluralized noun interpolated 
    */
    public static String pluralizeFormat(String format, Integer numberOfThings, String nameOfThing){
        return pluralizeFormat(format, numberOfThings, new Noun(nameOfThing));
    }

    /**
    * @description Return a string containing a singular or plural version of a noun, based on number, and the number,
    * using string substitution. 
    * Examples:
    * pluralizeFormat('Found {!number} eligible {!noun}', 2, new Noun('Rebate')) returns 'Found two eligible Rebates'
    * pluralizeFormat('{!number} {!noun} found', 1, new Noun('Rebate')) returns 'one Rebate found'
    *
      * @param  format  Format string used to generate final string. Mark the place for the number with {!number}
      *         and the place for the noun with {!noun}
      * @param  numberOfThings  The number which will determine if we use plural or singular
      * @param  noun The noun, which will be used in singular or plural form
    *   
      * @return The format string, with the number and pluralized noun interpolated 
    */
    public static String pluralizeFormat(String format, Integer numberOfThings, Noun noun){
        String numberString = NUMBER_TO_ENGLISH.containsKey(numberOfThings)
            ? NUMBER_TO_ENGLISH.get(numberOfThings)
            : numberOfThings.format();
        String nounString = pluralizeNoun(numberOfThings, noun);
        return format
                .replace('{!number}', numberString)
                .replace('{!noun}', nounString);
    }

    /**
    * @description Return a string containing a singular or plural version of a noun as well as a singluar or plural
    * verb, based on a number, and the number, using string substitution. 
    * Examples:
    * pluralizeSentence('{!number} {!noun} {!verb} attention', 2, 'Invoice', 'needs') 
    *       returns 'two Invoices need attention'
    * pluralizeSentence('{!number} {!noun} {!verb} direct deposit', 1, 'Check', 'uses') 
    *       returns 'one Check uses direct deposit'
    *
      * @param  format  Format string used to generate final string. Mark the place for the number with {!number},
      *         the place for the noun with {!noun}, and the place for the verb with {!verb}
      * @param  numberOfThings  The number which will determine if we use plural or singular
      * @param  nounString The noun which will be used in singular or plural form
      * @param  verbString The verb which will be used in singular or plural form
    *   
      * @return The format string, with the number, pluralized noun, and pluralized verb interpolated 
    */
    public static String pluralizeSentence(String format, Integer numberOfThings, String nounString, String verbString){
        return pluralizeSentence(format, numberOfThings, new Noun(nounString), new Verb(verbString));
    }

    /**
    * @description Return a string containing a singular or plural version of a noun as well as a singluar or plural
    * verb, based on a number, and the number, using string substitution. 
    * Examples:
    * pluralizeSentence('{!number} {!noun} {!verb} attention', 2, new Noun('child', 'children'), 'needs') 
    *       returns 'two children need attention'
    * pluralizeSentence('{!number} {!noun} {!verb} direct deposit', 1, new Noun('Check'), 'uses') 
    *       returns 'one Check uses direct deposit'
    *
      * @param  format  Format string used to generate final string. Mark the place for the number with {!number},
      *         the place for the noun with {!noun}, and the place for the verb with {!verb}
      * @param  numberOfThings  The number which will determine if we use plural or singular
      * @param  noun The noun which will be used in singular or plural form
      * @param  verbString The verb which will be used in singular or plural form
    *   
      * @return The format string, with the number, pluralized noun, and pluralized verb interpolated 
    */
    public static String pluralizeSentence(String format, Integer numberOfThings, Noun noun, String verbString){
        return pluralizeSentence(format, numberOfThings, noun, new Verb(verbString));
    }

    /**
    * @description Return a string containing a singular or plural version of a noun as well as a singluar or plural
    * verb, based on a number, and the number, using string substitution. 
    * Examples:
    * pluralizeSentence('{!number} {!noun} {!verb} unresolved issues', 2, 'Invoice', new Verb('has', 'have')) 
    *       returns 'two Invoices have unresolved issues'
    * pluralizeSentence('{!number} {!noun} {!verb} validation', 1, 'Check', new Verb('fails', 'fail')) 
    *       returns 'one Check fails validation'
    *
      * @param  format  Format string used to generate final string. Mark the place for the number with {!number},
      *         the place for the noun with {!noun}, and the place for the verb with {!verb}
      * @param  numberOfThings  The number which will determine if we use plural or singular
      * @param  nounString The noun which will be used in singular or plural form
      * @param  verb The verb which will be used in singular or plural form
    *   
      * @return The format string, with the number, pluralized noun, and pluralized verb interpolated 
    */
    public static String pluralizeSentence(String format, Integer numberOfThings, String nounString, Verb verb){
        return pluralizeSentence(format, numberOfThings, new Noun(nounString), verb);
    }

    /**
    * @description Return a string containing a singular or plural version of a noun as well as a singluar or plural
    * verb, based on a number, and the number, using string substitution. 
    * Examples:
    * pluralizeSentence('{!number} {!noun} {!verb} faulty', 2, new Noun('truss', 'trusses'), new Verb('is', 'are')) 
    *       returns 'two trusses are faulty'
    * pluralizeSentence('{!number} {!noun} {!verb}', 1, new Noun('ox', 'oxen'), new Verb('passes', 'pass')) 
    *       returns 'one ox passes'
    *
      * @param  format  Format string used to generate final string. Mark the place for the number with {!number},
      *         the place for the noun with {!noun}, and the place for the verb with {!verb}
      * @param  numberOfThings  The number which will determine if we use plural or singular
      * @param  noun The noun which will be used in singular or plural form
      * @param  verb The verb which will be used in singular or plural form
    *   
      * @return The format string, with the number, pluralized noun, and pluralized verb interpolated 
    */
    public static String pluralizeSentence(String format, Integer numberOfThings, Noun noun, Verb verb){
        String verbString = isPlural(numberOfThings) ? verb.getPlural() : verb.getSingular();
        return pluralizeFormat(format, numberOfThings, noun)
                .replace('{!verb}', verbString);
    }


}