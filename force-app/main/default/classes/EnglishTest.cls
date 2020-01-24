@isTest
public with sharing class EnglishTest {
    @isTest
    static void itShouldGiveSingularForSimpleString(){
        Test.startTest();
        String pluralizedString = English.pluralize(1, 'part');
        Test.stopTest();
        System.assertEquals('one part', pluralizedString);
    }

    @isTest
    static void itShouldGivePluralForSimpleString(){
        Test.startTest();
        String pluralizedString = English.pluralize(5, 'part');
        Test.stopTest();
        System.assertEquals('five parts', pluralizedString);
    }

    @isTest
    static void itShouldGiveSingularForNoun(){
        Test.startTest();
        String pluralizedString = English.pluralize(1, new English.Noun('child', 'children'));
        Test.stopTest();
        System.assertEquals('one child', pluralizedString);
    }

    @isTest
    static void itShouldGivePluralForNoun(){
        Test.startTest();
        English.Noun noun = new English.Noun('child', 'children');
        String pluralizedString = English.pluralize(10, noun);
        Test.stopTest();
        System.assertEquals('ten children', pluralizedString);
    }

    @isTest
    static void itShouldGivePluralForNounWhenZero(){
        Test.startTest();
        English.Noun noun = new English.Noun('child', 'children');
        String pluralizedString = English.pluralize(0, noun);
        Test.stopTest();
        System.assertEquals('no children', pluralizedString);
    }

    @isTest
    static void itShouldFormatLongNumbers(){
        User testUser = [SELECT Id 
            FROM User 
            WHERE LanguageLocaleKey = 'en_US' 
            AND isActive = true
            LIMIT 1];
        String actual;
        System.runas(testUser){
            Test.startTest();
            actual = English.pluralize(1234567, 'idea');
            Test.stopTest();
        }
        String expected = '1,234,567 ideas';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeFormatWithStringInPlural(){
        Test.startTest();
        String actual = English.pluralizeFormat('Found {!number} eligible {!noun}', 2, 'Account');
        Test.stopTest();
        String expected = 'Found two eligible Accounts';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeFormatWithStringInSingular(){
        Test.startTest();
        String actual = English.pluralizeFormat('{!number} {!noun} found', 1, 'Account');
        Test.stopTest();
        String expected = 'one Account found';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeFormatWithNounInSingular(){
        Test.startTest();
        String actual = English.pluralizeFormat('{!number} {!noun} found', 1, new English.Noun('Account'));
        Test.stopTest();
        String expected =  'one Account found';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeFormatWithNounInPlural(){
        Test.startTest();
        String actual = English.pluralizeFormat('Found {!number} eligible {!noun}', 2, new English.Noun('Account'));
        Test.stopTest();
        String expected =  'Found two eligible Accounts';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeSentenceWithTwoStringsInSingular(){
        Test.startTest();
        String actual = English.pluralizeSentence('{!number} {!noun} {!verb} direct deposit', 1, 'check', 'uses');
        Test.stopTest();
        String expected = 'one check uses direct deposit';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeSentenceWithTwoStringsInPlural(){
        Test.startTest();
        String actual = English.pluralizeSentence('{!number} {!noun} {!verb} attention', 2, 'part', 'needs');
        Test.stopTest();
        String expected =  'two parts need attention';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeSentenceWithNounAndStringInSingular(){
        Test.startTest();
        String actual = English.pluralizeSentence('{!number} {!noun} {!verb} zip+4', 1, new English.Noun('address', 'addresses'), 'uses');
        Test.stopTest();
        String expected = 'one address uses zip+4';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeSentenceWithNounAndStringInPlural(){
        Test.startTest();
        String actual = English.pluralizeSentence('{!number} {!noun} {!verb} attention', 2, new English.Noun('child', 'children'), 'needs');
        Test.stopTest();
        String expected = 'two children need attention';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeSentenceWithStringAndVerbInSingular(){
        Test.startTest();
        String actual = English.pluralizeSentence('{!number} {!noun} {!verb} validation', 1, 'check', new English.Verb('passes', 'pass'));
        Test.stopTest();
        String expected = 'one check passes validation';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeSentenceWithStringAndVerbInPlural(){
        Test.startTest();
        String actual = English.pluralizeSentence('{!number} {!noun} {!verb} unresolved issues', 2, 'part', new English.Verb('has', 'have'));
        Test.stopTest();
        String expected =  'two parts have unresolved issues';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeSentenceWithNounAndVerbInPlural(){
        Test.startTest();
        String actual = English.pluralizeSentence('{!number} {!noun} {!verb} faulty', 2, new English.Noun('truss', 'trusses'), new English.Verb('is', 'are'));
        Test.stopTest();
        String expected = 'two trusses are faulty';
        System.assertEquals(expected, actual);
    }

    @isTest
    static void itShouldPluralizeSentenceWithNounAndVerbInSingular(){
        Test.startTest();
        String actual = English.pluralizeSentence('{!number} {!noun} {!verb}', 1, new English.Noun('ox', 'oxen'), new English.Verb('passes', 'pass'));
        Test.stopTest();
        String expected = 'one ox passes';
        System.assertEquals(expected, actual);
    }

}