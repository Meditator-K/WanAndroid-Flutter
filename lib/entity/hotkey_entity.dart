class HotkeyEntity {
	int? visible;
	String? link;
	String? name;
	int? id;
	int? order;

	HotkeyEntity({this.visible, this.link, this.name, this.id, this.order});

	HotkeyEntity.fromJson(Map<String, dynamic> json) {
		visible = json['visible'];
		link = json['link'];
		name = json['name'];
		id = json['id'];
		order = json['order'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['visible'] = this.visible;
		data['link'] = this.link;
		data['name'] = this.name;
		data['id'] = this.id;
		data['order'] = this.order;
		return data;
	}
}
