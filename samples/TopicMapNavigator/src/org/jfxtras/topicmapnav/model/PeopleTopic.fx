package org.jfxtras.topicmapnav.model;

public class PeopleTopic {
  public var name: String on replace {
    name = name.replaceAll("&amp;", "&");
    //println("PeopleTopic#id:{name}");
  };
  public var id: String;
  public var imageUrl: String;
  public var people:TeamTopic[];

}





