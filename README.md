Unofficial Stack Overflow API
=============================
==IMPORTANT=== This repo is no longer maintained.

Taking inspiration from [this post] on Stackoverflow, we decided to make an API for the Stackoverflow Careers website as a final project for [Makers Academy]. 

We wrote two very polite scrapers which gather new jobs / companies posted on Stackoverflow on a daily basis. The data is availabe in JSON format on Heroku at various URLs on http://stackable.herokuapp.com, for example: 

- **/api/companies** (*all companies*)
- **/api/jobs**  (*all jobs*)
- **/api/relocation** (*relocation offered*)
- **/api/remote** (*remote allowed*)
- **/api/senior** (*senior position*)
- **/api/jobs/tags/ruby&java** (*jobs by tags - separated by ampersand*)
- **/api/companies/benefits/gym** (*companies by benefits - keywords separated by ampersand*)
- **/api/jobs/location/london** (*jobs by location*)

(The prefix /api/ was added with Grape. If you simply open the root it will return a 404 Not Found!)

Usage
-----
It is possible to query the API by making a GET request to the following URLs:

| URL | Paginated? |
| ---- | :------: |
| http://stackable.herokuapp.com/api/jobs | Yes |
| http://stackable.herokuapp.com/api/companies | Yes |
| http://stackable.herokuapp.com/api/relocation | No |
| http://stackable.herokuapp.com/api/senior | No |
| http://stackable.herokuapp.com/api/remote | No |
| http://stackable.herokuapp.com/api/jobs/tags/ruby | No |
| http://stackable.herokuapp.com/api/jobs/tags/ruby&java | No |
| http://stackable.herokuapp.com/api/jobs/location/london | No |
| http://stackable.herokuapp.com/api/companies/benefits/gym | No |
| http://stackable.herokuapp.com/api/companies/benefits/gym | No |
| http://stackable.herokuapp.com/api/companies/benefits/gym&dental | No |

We strongly recommend using a Chrome plugin to 'prettify' the JSON output, such as **JSON Formatter**.

Example
------
The query below will return a list of the first 30 jobs available. The command -i will show you the headers, where you can see the second page available in the series: http://stackable.herokuapp.com/api/companies?page=2&per_page=30

From the command line, type:

```
curl -i http://stackable.herokuapp.com/api/jobs
```
As you may have gathered, results are paginated for two queries: /api/jobs and /api/companies. URLs are built by appending the following string to the main URL:

```
?page=2&per_page=30
```
To make a GET request you can either use curl or net-http straight from your Ruby code. There are other solutions, one of which is our [Gem Stackable]. This makes it easier to pull jobs from your Ruby code as it handles GET requests for you (similarly to what Octokit does for Github API).

However, the Stackable Gem still cannot handle pagination (it will be able to soon). For this reason, all queries will work fine except get_all_companies and all_jobs, which will only return the first 30 jobs / companies. For these two queries, please query the API directly for now.

Important
---------
While [all Jobs] and [all Companies] listings are paginated, all other queries aren't yet. This may slow down the API. We will launch pagination for all results as soon as possible. 

Tech Stack
----------

This API was built with the [Grape Gem]. Full tech stack:

- Grape;
- Postgres;
- DataMapper;
- Heroku;
- DataMapper plugins

Although it's very quick to get things going with DataMapper, we soon came to know its limits and had to pass raw SQL queries to get what we wanted. We also had to integrate with a few other plugins - among which the custom 'ilike' function for case-insensitive queries.

Grape::Entity::DSL module made it possible to avoid exposing user-unfriendly database columns such as the 'scraping_round'.

:small_red_triangle_down: Gems: Grape, Grape Entity, Grape-pagination, Nokogiri.

[this post]: http://meta.stackoverflow.com/questions/158005/stackoverflow-careers-api
[all Jobs]: http://stackable.herokuapp.com/api/jobs
[all Companies]: http://stackable.herokuapp.com/api/companies
[Gem Stackable]: https://github.com/mfisher90/stackable
[Grape]: https://github.com/intridea/grape
[Makers Academy]: http://www.makersacademy.com/
