# Thoughts
- The %trail gall agent should be kept as small as possible.
- There are many possible data sources, implying that the %trail gall agent should not include data source parsing knowledge
- Not all users will care about all data sources.
- This implies
  - Data sources should be separate from the %trail gall agent
  - There should be a mechanism to register their existence with the main gall agent
  - There could be 3rd party data source parsers that can be install separately from the %trail desk
