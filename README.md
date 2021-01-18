# README

# Requirements
 - Docker
 - Docker Compose
 - Nothing running on ports 3000 and 9200

# How to Run
 - `docker-compose up`

Yep! It's that simple! The application will be available on `http://localhost:3000`, it may take a couple of minutes on the first run depending on your internet bandwith.

# How to Run Tests
 - First make sure that you already ran `docker-compose up` and the server responded at least once.
 - `docker-compose run --rm app bundle exec rspec`

The command above will also generate a coverage report that can be found inside `tmp/coverage` folder
 
# Architectural Notes
- JSON:API was adopted as a specification to build requests responses, more info on: [json-api.org](https://jsonapi.org/)  
- Rubocop was chosen as a linter.    
- All available endpoints have some form of cache that will be initialized after the first request, that may be dependant on given query parameters.  
- To speed up that first request a worker with sidekiq gem to warmup the cache could have been implement, but I was short on time :p

# API Resources

## Most accessed questions

Provided on `/v1/question_accesses`, this endpoint accepts **year**, **month** and **week** as query parameters.   
Must be noted that to filter by month or week, **year must also be informed**. Questions are sorted in descending order by times_accessed

**Bonus Feature**: You may also use [Sparse Fieldsets](https://jsonapi.org/format/#fetching-sparse-fieldsets) from json-api to filter attributes

## Requests Examples
### Most accessed questions by week
`curl --location --request GET 'http://localhost:3000/v1/question_accesses?year=2020&week=2'`

### Most accessed questions by month
`curl --location --request GET 'http://localhost:3000/v1/question_accesses?year=2020&month=2'`

### Most accessed questions by year
`curl --location --request GET 'http://localhost:3000/v1/question_accesses?year=2020'`

### Most accessed questions by year with sparsed fields
`curl --location --request GET 'http://localhost:3000/v1/question_accesses?year=2020&fields[question][]=text&fields[question][]=times_accessed'`
## Response Example
```
{
    "data": [
        {
            "id": "6369",
            "type": "question",
            "attributes": {
                "statement": "Quia nostrum ducimus aperiam.",
                "text": "Error ipsa eos. Minima vitae et. Minus sed dolor.",
                "answer": "D",
                "daily_access": 15,
                "discipline": "inglês",
                "times_accessed": 456846
            }
        },
        {
            "id": "9212",
            "type": "question",
            "attributes": {
                "statement": "Et aperiam illum accusamus.",
                "text": "Et ad qui. Omnis ut quia. Mollitia aut non.",
                "answer": "D",
                "daily_access": 73,
                "discipline": "inglês",
                "times_accessed": 403606
            }
        },
        {...}, {...}, ...
    ],
    "meta": {
        "year": "2020",
        "week": "2"
    }
}

```

## Most accessed disciplines on last 24h
Provided on `/v1/disciplines` this endpoints does not accepts any parameter, disciplines are sorted in descending order by times_accessed  
Note: Sorting is actually done on the sum of `daily_access` on `Question` model, however `times_accessed` was used to represent that sum for each discipline.

## Request example  
`curl --location --request GET 'http://localhost:3000/v1/disciplines'`

## Response Example

```
{
    "data": [
        {
            "id": "geografia",
            "type": "discipline",
            "attributes": {
                "name": "geografia",
                "times_accessed": 6242
            }
        },
        {
            "id": "literatura",
            "type": "discipline",
            "attributes": {
                "name": "literatura",
                "times_accessed": 5149
            }
        },
        {...}, {...}, ...
    ]
}
```