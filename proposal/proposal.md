# Trail - An Outdoor Activity Tracker for Urbit
Outdoor workout trackers, especially when including social features, generally require users to submit sensitive location data to their servers. With %trail , an Urbit user can keep control over their sensitive location data with their own secure, private server. In addition, social features, such as workout challenges, will not require revealing a user’s social graph to a third party.

## App UI
Due to the nature of location tracking and map displays in mobile, it would seem best to have two different UIs depending on the context.
When out in the world and recording a run/bike ride/hike, the user should be using a native mobile experience.

When on a laptop reviewing previous exercises, a user would be using grid (browser), and therefore, will not have the capability to record exercise.

## Gall app API
## Milestones
- **Milestone 1**: Gall app backend with basic Grid UI
  - **Pokes**
    - **%sync-activity**: Syncs full activity data, including activity-type and path. 
    - **%save-settings**: Saves settings, including whether distance should be measured in miles or km
  - **Peeks**
    - View details of a previously completed activity
  - **Grid**
    - View summary of previously completed activities
- **Milestone 2**: Ingest data from Strava API
  - Create gall agent
    - Parse Strava data and save to %trail agent
  - Grid UI
    - Ability to enter Strava API access token
- **Milestone 3**: Basic outdoor activity tracking on iPhone
  - **Gall agent**
    - **Pokes**
      - **%delete-activity**: Deletes an activity.
  - Choose between metric and imperial unit systems
  - Live tracking of an outdoor activity
  - Path on map updates as user moves
  - Displays current pace, total distance, average speed
  - View summary of previously completed activity
  - View details of a previously completed activity
- **Milestone 4**: Grid application developed in React
  - View details of a previously completed activity
  - Display distances in either metric or imperial units
  - View summary data
    - How much time, how far in the last week, month, year, etc.
  - Edit activitiy
    - Can modify the time of the workout to remove a time period at the end of a workout
- **Milestone 5**: Ingest data from common activity file types
  - Create gall agent
    - Parse .gpx files
    - Parse .tcx files
  - Grid UI
    - Ability to upload files to be parsed
- **Milestone 6**: New groups integration
  - Create a challenge with other users, which either creates a multi-user group for chatting or uses an existing one that contains the same members.
  - When a participant completes a workout, a summary gets posted to the multi-user group
  - Other challenge participants can view details of the workout

## Future Integrations
When more of the base layer of health applications get built out, there are some exciting features that can be created by combining data from other apps.
- A workout routine / training program. This app could also include weightlifting programs as well as cardio.
  - Integrates with
    - Calendar
    - Groups
  - Can be used by
    - Users can develop their own routines
    - Personal trainers can provide users with custom routines
- Exercise challenges. Challenge your friends to see who can accumulate the most miles in a month
  - Integrates with
    - Calendar
    - Groups
    - Chat
    - %pals / %whom
  - Can be used by
    - Groups
- Spin class. Join a decentralized spin class
  - Integrates with
    - Web RTC
    - Exercise bike
    - Groups
  - Can be used by
    - Spin class instructors
- Calorie estimation
  - Integrates with
    - Heartrate
    - Weight

## About Me
I am a recent Hoon School Live and App School Live graduate. I also have 18 years of experience developing web apps and APIs using various back-end technologies including .NET and node.js, as well as modern JavaScript front-end frameworks including React/Redux, Vue, and Svelte over the past 6 years.

As importantly, I am extremely passionate about having fitness tracking and biometric data integrated with Urbit. It was the first use case that came to mind while reading the initial blog post describing Urbit.
