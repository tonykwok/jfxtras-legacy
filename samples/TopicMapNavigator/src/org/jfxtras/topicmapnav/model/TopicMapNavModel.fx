/*
 * TopicMapNavModel.fx
 *
 * The main model for the Topic Map Navigator program
 *
 */

package org.jfxtras.topicmapnav.model;

import javafx.io.http.HttpRequest;
import javafx.animation.*;
import org.jfxtras.data.pull.*;
import org.jfxtras.scene.control.data.SequenceObjectDataProvider;

/**
 * Reference to the singleton instance of this model class
 */
var modelInstance:TopicMapNavModel;

/**
 * Obtain a reference to the singleton instance of this model class,
 * creating one if necessary
 */
public function getInstance():TopicMapNavModel {
  if (modelInstance == null) {
    modelInstance = TopicMapNavModel {};
  }
  return modelInstance;
}

/**
 * The main model for the Topic Map Navigator program
 */
public class TopicMapNavModel {

  /**
   * Height of the images that we'll be working with
   * TODO: If this stays in the model, it should be set from the UI
   */
  public def IMAGE_HEIGHT:Integer = 140;

  /**
   * Artist for which we're searching bandmates
   */
  public var artistToSearch:String = "/en/aynsley_dunbar";

  /**
   * Name for which we're finding matches and ids
   */
  public var nameToFind:String = "Aynsley Dunbar";

  /**
   * Controls whether to show topics that don't have images
   */
  public var showTopicsThatHaveNoImage:Boolean = false;

  /**
   * Controls whether to show the location map (currently a Google map)
   */
  public var showLocationMap:Boolean = true;

  /**
   * Controls whether to show the location map (currently a Google map)
   */
  public var googleMapLongitude = 0.0;
  public var googleMapLatitude = 0.0;

  /**
   * Sequence that holds the topic (id, URL and names) for the teams
   */
  public var teamTopics:TeamTopic[];

  /**
   * Sequence that holds the topic (id, URL and names) for all people of a
   * type.
   * TODO: Perhaps specialize for specific types, like soccer players
   * TODO: Create a sequence of these, with each one rendered as a Table
   *       in its own tab
   */
  public var allPeopleOfGivenTypeTopics:PeopleTopic[] = [
    PeopleTopic {
      id: "111"
      name: "Aaa Aaaa"
      imageUrl: "http://111"
    },
    PeopleTopic {
      id: "222"
      name: "Bbb Bbbb"
      imageUrl: "http://222"
    },
  ];

  public var dummy:PeopleTopic[] = [
    PeopleTopic {
      id: "333"
      name: "Ccc Cccc"
      imageUrl: "http://333"
    },
    PeopleTopic {
      id: "444"
      name: "Ddd Dddd"
      imageUrl: "http://444"
    },
  ];


  /**
   * A reference to the HTTP request, for the purpose of monitoring progress
   */
  public var req:HttpRequest;

  /**
   * The root class that will hold the object graph from the JSON results
   */
  public var freebaseResult:FreebaseResult;

  /**
   * The root class that will hold the object graph from the JSON results
   */
  public var freebaseSearchResult:FreebaseSearchResult;

  /**
   * The base URL for the freebase query
   */
  def freebaseURL = "http://www.freebase.com/api/service/mqlread?";

  /**
   * The base URL for a freebase search request
   */
  def freebaseSearchURL = "http://www.freebase.com/api/service/search?";

  /**
   * The base URL to get a freebase image
   */
  public def freebaseImageURL = "http://img.freebase.com/api/trans/image_thumb";

  /**
   * Timeline that controls the lower Shelf fade-in
   */
  public var shelfOpacity:Number;

  /**
   * Timeline that controls the lower Shelf fade-in
   */
  public var fadeInTimeline = Timeline {
    keyFrames: [
      at(0.0s) { shelfOpacity => 0.0 },
      at(4.0s) { shelfOpacity => 1.0 tween Interpolator.EASEIN}
    ]
  }

  /**
   * Index into groups list
   */
  public var groupOneIndex:Integer on replace {
    fadeInTimeline.playFromStart();

    // Choose the middle one
    def numArtists:Integer = sizeof teamTopics[groupOneIndex].people;
    artistTwoIndex = if (numArtists > 1) numArtists / 2 else 0;

    groupOneName = teamTopics[groupOneIndex].name;
  };

  /**
   * Name of the currently selected band
   */
  var groupOneName:String;

  /**
   * Controls whether the suggestions list is visible
   */
  public var suggestionsVisible:Boolean;

  /**
   * Controls whether info box is visible
   */
  public var infoBoxVisible:Boolean;

  /**
   * Name displayed in the info box
   */
  public var infoBoxName:String;

  /**
   * Index into artists list
   */
  public var artistTwoIndex:Integer;

  /**
   * Create a search query and invoke the JSON handler
   * Experimenting with putting data from a query into a JFXtras Table,
   * so this function is currently commented out.
   */
  /*
  public function obtainNamesForType(type:String, table:org.jfxtras.scene.control.Table) {
    var queryUrl = "{freebaseURL}query=\{\"query\":"
      " [\{ "
      "   \"/common/topic/image\": [\{ "
      "     {commonTopicImageJSON()} "
      "   \}], "
      "   \"name\":  null, "
      "   \"id\":    null, "
      "   \"limit\": 100, "
      "   \"sort\": \"name\", "
      "   \"current_team\": [\{ "
      "     \"id\": null "
      "   \}], "
      "   \"type\":  \"/soccer/football_player\" "
      " \}] \}";

    println("queryUrl:{queryUrl}");
    var albumHandler:JSONHandler = JSONHandler {
      rootClass: "org.jfxtras.topicmapnav.model.FreebaseSearchResult"
      onDone: function(obj, isSequence): Void {
        freebaseSearchResult = obj as FreebaseSearchResult;
        println("# of obtainNamesForType results:{sizeof freebaseSearchResult.result},freebaseSearchResult:{freebaseSearchResult.code}");
        req.stop();

        // Load up the AllPeopleOfGivenTypeTopic sequence with people of
        // the given type
        //delete allPeopleOfGivenTypeTopics;
        for (person in freebaseSearchResult.result) {
          def peopleTopic = PeopleTopic {
            id: person.id
            name: person.name
            imageUrl: "{freebaseImageURL}{person.id}?maxheight={IMAGE_HEIGHT}"
          };
          insert peopleTopic into allPeopleOfGivenTypeTopics;
          table.rows = allPeopleOfGivenTypeTopics;
        };
      }
    };
    req = HttpRequest {
      location: queryUrl
      onInput: function(is: java.io.InputStream) {
        albumHandler.parse(is);
      }
    };
    req.start();
  }
  */

  /**
   * Create a search query and invoke the JSON handler
   */
  public function obtainIdForArtistPartialName(artistPartialName:String) {
    suggestionsVisible = true;
    nameToFind = artistPartialName;
    def partialName = artistPartialName.replace(" ", "+");
    var searchUrl = "{freebaseSearchURL}prefix={partialName}&type=/common/topic&limit=10&mql_output=[\{\"id\":null,\"name\":null\}]";
    //var searchUrl = "{freebaseSearchURL}prefix={partialName}&type=/people/person&limit=10&mql_output=[\{\"id\":null,\"name\":null\}]";

    //println("searchUrl:{searchUrl}");
    var albumHandler:JSONHandler = JSONHandler {
      rootClass: "org.jfxtras.topicmapnav.model.FreebaseSearchResult"
      onDone: function(obj, isSequence): Void {
        freebaseSearchResult = obj as FreebaseSearchResult;
        //println("# of search results:{sizeof freebaseSearchResult.result},freebaseSearchResult:{freebaseSearchResult.code}");
        req.stop();
      }
    };
    req = HttpRequest {
      location: searchUrl
      onInput: function(is: java.io.InputStream) {
        albumHandler.parse(is);
      }
    };
    req.start();
  }

  /**
   * Create the Freebase query and invoke the JSON handler
   */
  public function obtainGroupsForArtist(artistFreebaseId:String) {
    suggestionsVisible = false;
    artistToSearch = artistFreebaseId;
    var queryUrl = "{freebaseURL}query=\{\"query\":"
      " \{ "
      "   \"/common/topic/image\": [\{ "
      "     \"id\": null, "
      "     \"optional\": \"optional\" " //TODO: Use {commonTopicImageJSON()} ?
      "   \}], "

/*
      "   \"/soccer/football_player/current_team\": [\{ "
      "     \"/soccer/football_roster_position/team\": [\{ "
      "       \"name\": null, "
      "       \"id\":   null, "
      "       \"/common/topic/image\": [\{ "
      "         {commonTopicImageJSON()} "
      "       \}], "
      "       \"/soccer/football_team/current_roster\": [\{ "
      "         \"player\": [\{ "
      "           \"name\": null, "
      "           \"id\":   null, "
      "           \"/common/topic/image\": [\{ "
      "             {commonTopicImageJSON()} "
      "           \}] "
      "         \}], "
      "         \"optional\": \"optional\" "
      "       \}] "
      "     \}], "
      "     \"optional\": \"optional\" "
      "   \}], "
*/

      "   \"/music/group_member/membership\": [\{ "
      "     \"group\": \{ "
      "       \"name\": null, "
      "       \"id\":   null, "
      "       \"/common/topic/image\": [\{ "
      "         \"id\": null, "
      "         {commonTopicImageJSON()} "
      "       \}], "
      "       \"/music/musical_group/member\": [\{ "
      "         \"member\": \{ "
      "           \"name\": null, "
      "           \"id\":   null, "
      "           \"/common/topic/image\": [\{ "
      "             \"id\": null, "
      "               {commonTopicImageJSON()} "
      "           \}] "
      "         \} "
      "       \}] "
      "     \}, "
      "     \"optional\": \"optional\" "
      "   \}], "

      "   \"/user/jlweaver/default_domain/javafx_concept/super_concepts\": [\{ "
      "     \"name\": null, "
      "     \"id\":   null, "
      "     \"/common/topic/image\": [\{ "
      "       \"id\": null, "
      "       {commonTopicImageJSON()} "
      "     \}], "
      "     \"/user/jlweaver/default_domain/javafx_concept/sub_concepts\": [\{ "
      "       \"name\": null, "
      "       \"id\":   null, "
      "       \"/common/topic/image\": [\{ "
      "         \"id\": null, "
      "         {commonTopicImageJSON()} "
      "       \}] "
      "     \}], "
      "     \"optional\": \"optional\" "
      "   \}], "

  /*
      "   \"/american_football/football_player/current_team\": [\{ "
      "     \"/american_football/football_roster_position/team\": [\{ "
      "       \"name\": null, "
      "       \"id\":   null, "
      "       \"/common/topic/image\": [\{ "
      "         {commonTopicImageJSON()} "
      "       \}], "
      "       \"/american_football/football_team/current_roster\": [\{ "
      "         \"player\": [\{ "
      "           \"name\": null, "
      "           \"id\":   null, "
      "           \"/common/topic/image\": [\{ "
      "             {commonTopicImageJSON()} "
      "           \}] "
      "         \}], "
      "         \"optional\": \"optional\" "
      "       \}] "
      "     \}], "
      "     \"optional\": \"optional\" "
      "   \}], "

      "   \"/american_football/football_player/former_teams\": [\{ "
      "     \"/american_football/football_historical_roster_position/team\": [\{ "
      "       \"name\": null, "
      "       \"id\":   null, "
      "       \"/common/topic/image\": [\{ "
      "         \"id\": null, "
      "         \"optional\": \"optional\" "
      "       \}], "
      "       \"/american_football/football_team/historical_roster\": [\{ "
      "         \"player\": [\{ "
      "           \"name\": null, "
      "           \"id\":   null, "
      "           \"/common/topic/image\": [\{ "
      "             \"id\": null, "
      "             \"optional\": \"optional\" "
      "           \}] "
      "         \}], "
      "         \"optional\": \"optional\" "
      "       \}] "
      "     \}], "
      "     \"optional\": \"optional\" "
      "   \}], "

      "   \"/spaceflight/astronaut/missions\": [\{ "
      "     \"name\": null, "
      "     \"id\":   null, "
      "     \"/common/topic/image\": [\{ "
      "       {commonTopicImageJSON()} "
      "     \}], "
      "     \"/spaceflight/space_mission/astronauts\": [\{ "
      "       \"name\": null, "
      "       \"id\":   null, "
      "       \"/common/topic/image\": [\{ "
      "         {commonTopicImageJSON()} "
      "       \}], "
      "       \"optional\": \"optional\" "
      "     \}], "
      "     \"optional\": \"optional\" "
      "   \}], "

      "   \"/astronomy/orbital_relationship/orbited_by\": [\{ "
      "     \"name\": null, "
      "     \"id\":   null, "
      "     \"/common/topic/image\": [\{ "
      "       \"id\": null, "
      "       \"optional\": \"optional\" "
      "     \}], "
      "     \"optional\": \"optional\", "
      "     \"/astronomy/orbital_relationship/orbited_by\": [\{ "
      "       \"name\": null, "
      "       \"id\":   null, "
      "       \"/common/topic/image\": [\{ "
      "         \"id\": null, "
      "         \"optional\": \"optional\" "
      "       \}], "
      "       \"optional\": \"optional\" "
      "     \}] "
      "   \}], "

      "   \"/location/location/contains\": [\{ "
      "     \"name\": null, "
      "     \"id\":   null, "
      "     \"/common/topic/image\": [\{ "
      "       \"id\": null, "
      "       \"optional\": \"optional\" "
      "     \}], "
      "     \"optional\": \"optional\" "
      "   \}], "
      
      "   \"/book/author/works_written\": [\{ "
      "     \"name\": null, "
      "     \"id\":   null, "
      "     \"/common/topic/image\": [\{ "
      "       \"id\": null, "
      "       \"optional\": \"optional\" "
      "     \}], "
      "     \"optional\": \"optional\" "
      "   \}], "
  */

      "   \"id\":   \"{artistFreebaseId}\", "
      "   \"name\": null, "

      "   \"/people/person/place_of_birth\": \{ "
      "     \"name\": null, "
      "     \"/location/location/geolocation\": \{ "
      "       \"latitude\":     null, "
      "       \"longitude\":     null "
      "     \}, "
      "     \"optional\": \"optional\" "
      "   \} "
      " \} \}";

    println("queryUrl:{queryUrl}");
    var albumHandler:JSONHandler = JSONHandler {
      rootClass: "org.jfxtras.topicmapnav.model.FreebaseResult"
      onDone: function(obj, isSequence): Void {
        freebaseResult = obj as FreebaseResult;
        req.stop();

        delete teamTopics;

        // Load up the TeamTopic sequence with music groups
        for (grp in freebaseResult.result.musicGroupMemberMembership) {
          def teamTopic = TeamTopic {
            id: grp.group.id
            imageUrl: "{freebaseImageURL}{grp.group.id}?maxheight={IMAGE_HEIGHT}"
            name: grp.group.name
          };
          insert teamTopic into teamTopics;

          // Create and load PeopleTopic sequences for each team
          for (mmbr in freebaseResult.result.
                       musicGroupMemberMembership[indexof grp].
                       group.musicMusicalGroupMember) {
            def peopleTopic = PeopleTopic {
              id: mmbr.member.id
              imageUrl: "{freebaseImageURL}{mmbr.member.id}?maxheight={IMAGE_HEIGHT}"
              name: mmbr.member.name
            };
            insert peopleTopic into teamTopic.people;
          }
        };

        // Load up the TeamTopic sequence with current soccer team
        for (grpA in freebaseResult.result.soccerFootballPlayerCurrentTeam) {
          for (grpB in grpA.soccerFootballRosterPositionTeam) {
            def teamTopic = TeamTopic {
              id: grpB.id
              imageUrl: "{freebaseImageURL}{grpB.id}?maxheight={IMAGE_HEIGHT}"
              name: grpB.name
            };
            insert teamTopic into teamTopics;

            // Create and load PeopleTopic sequences for each team
            for (mmbrA in grpB.soccerFootballTeamCurrentRoster) {
              for (mmbrB in mmbrA.player) {
                def peopleTopic = PeopleTopic {
                  id: mmbrB.id
                  imageUrl: "{freebaseImageURL}{mmbrB.id}?maxheight={IMAGE_HEIGHT}"
                  name: mmbrB.name
                };
                insert peopleTopic into teamTopic.people;
              }
            }
          }
        };

        // Load up the TeamTopic sequence with the sob-concepts of the current concept
        for (grp in freebaseResult.result.userJlweaverDefaultDomainJavafxConceptSuperConcepts) {
          def teamTopic = TeamTopic {
            id: grp.id
            imageUrl: "{freebaseImageURL}{grp.id}?maxheight={IMAGE_HEIGHT}"
            name: grp.name
          };
          insert teamTopic into teamTopics;

          // Create and load PeopleTopic sequences for each team
          for (mmbr in freebaseResult.result.
                       userJlweaverDefaultDomainJavafxConceptSuperConcepts[indexof grp].
                       userJlweaverDefaultDomainJavafxConceptSubConcepts) {
            def peopleTopic = PeopleTopic {
              id: mmbr.id
              imageUrl: "{freebaseImageURL}{mmbr.id}?maxheight={IMAGE_HEIGHT}"
              name: mmbr.name
            };
            insert peopleTopic into teamTopic.people;
          }
        };

        /*
        // Load up the TeamTopic sequence with orbiting celestial bodies
        for (grp in freebaseResult.result.astronomyOrbitalRelationshipOrbitedBy) {
          def teamTopic = TeamTopic {
            id: grp.id
            name: grp.name
          };
          insert teamTopic into teamTopics;
          //println("Inserted:{teamTopic.name}");

          // Create and load PeopleTopic sequences for each team
          for (mmbr in grp.astronomyOrbitalRelationshipOrbitedBy) {
            def peopleTopic = PeopleTopic {
              id: mmbr.id
              name: mmbr.name
            };
            insert peopleTopic into teamTopic.people;
          }
        };

        // Load up the TeamTopic sequence with location containment info
        // TODO (just one level for now, because it is quite large)
        for (grp in freebaseResult.result.locationLocationContains) {
          def teamTopic = TeamTopic {
            id: grp.id
            name: grp.name
          };
          insert teamTopic into teamTopics;
        };

        // Load up the TeamTopic sequence with books written
        // TODO (just one level for now, because it is quite large)
        for (grp in freebaseResult.result.bookAuthorWorksWritten) {
          def teamTopic = TeamTopic {
            id: grp.id
            name: grp.name
          };
          insert teamTopic into teamTopics;
        };

        // Load up the TeamTopic sequence with orbiting celestial bodies
        for (grp in freebaseResult.result.astronomyCelestialObject) {
          def teamTopic = TeamTopic {
            id: grp.id
            name: grp.name
          };
          insert teamTopic into teamTopics;
          //println("Inserted:{teamTopic.name}");

          // Create and load PeopleTopic sequences for each team
          for (mmbr in grp.astronomyOrbitalRelationshipOrbitedBy,
               mmbrB in mmbr.astronomyCelestialObject) {
            def peopleTopic = PeopleTopic {
              id: mmbrB.id
              name: mmbrB.name
            };
            insert peopleTopic into teamTopic.people;
          }
        };

        // Load up the TeamTopic sequence with space missions
        for (grp in freebaseResult.result.spaceflightAstronautMissions) {
          def teamTopic = TeamTopic {
            id: grp.id
            imageUrl: "{freebaseImageURL}{grp.id}?maxheight={IMAGE_HEIGHT}"
            name: grp.name
          };
          insert teamTopic into teamTopics;

          // Create and load PeopleTopic sequences for each team
          for (mmbr in freebaseResult.result.spaceflightAstronautMissions[indexof grp].
                       spaceflightSpaceMissionAstronauts) {
            def peopleTopic = PeopleTopic {
              id: mmbr.id
              imageUrl: "{freebaseImageURL}{mmbr.id}?maxheight={IMAGE_HEIGHT}"
              name: mmbr.name
            };
            insert peopleTopic into teamTopic.people;
          }
        };

        // Load up the TeamTopic sequence with current football team
        for (grpA in freebaseResult.result.americanFootballFootballPlayerCurrentTeam) {
          for (grpB in grpA.americanFootballFootballRosterPositionTeam) {
            def teamTopic = TeamTopic {
              id: grpB.id
              name: grpB.name
            };
            insert teamTopic into teamTopics;

            // Create and load PeopleTopic sequences for each team
            for (mmbrA in grpB.americanFootballFootballTeamCurrentRoster) {
              for (mmbrB in mmbrA.player) {
                def peopleTopic = PeopleTopic {
                  id: mmbrB.id
                  name: mmbrB.name
                };
                insert peopleTopic into teamTopic.people;
              }
            }
          }
        };

        // Load up the TeamTopic sequence with historical football teams
        for (grpA in freebaseResult.result.americanFootballFootballPlayerFormerTeams) {
          for (grpB in grpA.americanFootballFootballHistoricalRosterPositionTeam) {
            def teamTopic = TeamTopic {
              id: grpB.id
              name: grpB.name
            };
            insert teamTopic into teamTopics;

            // Create and load PeopleTopic sequences for each team
            for (mmbrA in grpB.americanFootballFootballTeamHistoricalRoster) {
              for (mmbrB in mmbrA.player) {
                def peopleTopic = PeopleTopic {
                  id: mmbrB.id
                  name: mmbrB.name
                };
                insert peopleTopic into teamTopic.people;
              }
            }
          }
        };
        */

        // Show birthplace on map
        def latStr = freebaseResult.result.peoplePersonPlaceOfBirth.locationLocationGeolocation.latitude;
        def longStr = freebaseResult.result.peoplePersonPlaceOfBirth.locationLocationGeolocation.longitude;

        // Control location shown on google map
        googleMapLatitude = if (latStr == "") 0.0 else Float.parseFloat(latStr);
        googleMapLongitude = if (longStr == "") 0.0 else Float.parseFloat(longStr);

        // Choose the middle one
        def numGroups:Integer = sizeof teamTopics;
        groupOneIndex = if (numGroups > 1) numGroups / 2 else 0;
      }
    };
    req = HttpRequest {
      location: queryUrl
      onInput: function(is: java.io.InputStream) {
        albumHandler.parse(is);
      }
    };
    req.start();
  }

  function commonTopicImageJSON() {
    if (showTopicsThatHaveNoImage) {
       " \"id\": null, \"optional\": \"optional\" "
    }
    else {
       " \"id\": null "
    }
  }
}
