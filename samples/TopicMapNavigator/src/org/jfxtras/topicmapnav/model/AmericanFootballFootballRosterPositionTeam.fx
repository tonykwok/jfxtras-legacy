package org.jfxtras.topicmapnav.model;
public class AmericanFootballFootballRosterPositionTeam {
  public var americanFootballFootballTeamCurrentRoster:AmericanFootballFootballTeamCurrentRoster[];
  public var commonTopicImage: ArtistImage[] ;
  public var name: String on replace {
    name = name.replaceAll("&amp;", "&");
  };
  public var id: String;
}