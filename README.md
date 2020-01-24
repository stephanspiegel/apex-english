# English for Apex

## Purpose

Allows messages like "5 Opportunity(s) is/are invalid" to become "Five Opportunities are invalid."

## Examples

```apex
System.debug(English.pluralizeFormat('Found {!number} eligible {!noun}.', 2, 'Account'));
```
outputs "Found two eligible Accounts."
```apex
English.Noun opportunityNoun = new English.Noun('opportunity', 'opportunities');
English.Verb toBeVerb = new English.Verb('is', 'are');
System.debug(English.pluralizeSentence('{!number} {!noun} {!verb} overdue.', 5, opportunityNoun, toBeVerb).capitalize());
```
produces "Five opportunities are overdue."
```apex
List<Integer> fibonacci = new List<Integer>{0, 1, 2, 3, 5, 7, 13};
English.Noun goose = new English.Noun('goose', 'geese');
English.Verb fly = new English.Verb('flies', 'fly');
for(Integer count : fibonacci){
    System.Debug(English.pluralizeSentence('{!number} {!noun} {!verb} south.', count, goose, fly).capitalize());
}
```
outputs:
```
No geese fly south.
One goose flies south.
Two geese fly south.
Three geese fly south.
Five geese fly south.
Seven geese fly south.
13 geese fly south.
```