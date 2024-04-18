# Hop Hop API

Hop Hop API is a Rails API project developed to provide back-end functionality for creating trips itineraries. Whenever visiting a different country, it can be hard to determine what you are going to do, and Hop Hop API will facilitate that. This API allows the front-end to access information about users trips, accommodations, and activities that they choose. All endpoints require a `user_id`.

## Setup

### Prerequisites
- Ruby (version >= 3.2.2)
- Rails (version >= 7.1.3.2)
- PostgreSQL

### Installation
1. Clone the repository:

    ```bash
    git clone <repository_url>
    ```

2. Install dependencies:

    ```bash
    bundle install
    ```

3. Set up the database:

    ```bash
    rails db:{drop,create,migrate,seed}
    ```

## Usage
- Start the server:

    ```bash
    rails server
    ```

- Access the API endpoints via http://localhost:3000/api/v1/

## Open API Documentation
Visit [Hop Hop API](http://https://api-hophop-9875038f278b.herokuapp.com/api-docs/index.html)

## Endpoints

### RESTful Endpoints

#### Trips Endpoints
- `GET /api/v1/trips`: 
  - Retrieve all trips.
- `POST /api/v1/trips`: 
  - Create a trip.
- `GET /api/v1/trips/:id`: 
  - Retrieve a specific trip by ID.
- `PATCH /api/v1/trips/:id`: 
  - Update a specific trip.
- `DELETE /api/v1/trips/:id`: 
  - Delete a specific trip.

#### Accommodations Endpoints
- `GET /api/v1/trips/:trip_id/accommodations`: 
  - Retrieve all the accommodations for a specific trip by ID. (usually just one but option for multiple in case of road trips or multiple stays)
- `POST /api/v1/trips/:trip_id/accommodations`: 
  - Create a new accommodation.
- `GET /api/v1/trips/:trip_id/accommodations/:id`: 
  - Get a specific accommodation by ID.
- `PATCH /api/v1/trips/:trip_id/accommodations/:id`: 
  - Update a specific accommodation.
- `DELETE /api/v1/trips/:trip_id/accommodations/:id`: 
  - Delete a specific accommodation.

#### Daily Itineraries Endpoint
- `GET /api/v1/trips/:trip_id/daily_itineraries`: 
  - Retrieve all the daily itineraries for a specific trip.

### Activities Endpoints

- `GET /api/v1/trips/:trip_id/daily_itineraries/:daily_itinerary_id/activities`: 
  - Retrieve all the activities for a specific daily itinerary by ID for a specific trip by ID.
- `POST /api/v1/trips/:trip_id/daily_itineraries/:daily_itinerary_id/activities`: 
  - Create a new activity.
- `GET /api/v1/trips/:trip_id/daily_itineraries/:daily_itinerary_id/activities/:id`: 
  - Get a specific activity by ID.
- `PATCH  /api/v1/trips/:trip_id/daily_itineraries/:daily_itinerary_id/activities/:id`: 
  - Update an activity.
- `DELETE /api/v1/trips/:trip_id/daily_itineraries/:daily_itinerary_id/activities/:id`: 
  - Delete an activity.

## Testing
This project includes automated tests written with RSpec. To run the tests, execute the following command:

```bash
bundle exec rspec
```

## Error Responses
The API follows a standard error response format for 400-series error codes. For example:

```json
{
    "errors": [
        {
            "detail": "Couldn't find Market with 'id'=123123123123"
        }
    ]
}
```

## Contributing
Contributions are welcome! Feel free to open issues or pull requests.

## License
This project is licensed under the [MIT License](LICENSE).

## Colaborators
- Hoa Dam
  - [LinkedIn](https://www.linkedin.com/in/hoa-dam-0ba4a716b/)
  - [GitHub](https://github.com/hoadam)
- Igor Magalhaes
  - [LinkedIn](https://www.linkedin.com/in/igorrmagalhaess/)
  - [GitHub](https://github.com/IgorrMagalhaess)
- Selena Hawamdeh
  - [LinkedIn](https://www.linkedin.com/in/selena-hawamdeh/)
  - [GitHub](https://github.com/Selena730)
- Yain Porter
  - [LinkedIn](https://www.linkedin.com/in/yainporter/)
  - [GitHub](https://github.com/yainporter)



