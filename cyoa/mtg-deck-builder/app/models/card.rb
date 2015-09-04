class Card < ActiveRecord::Base
  has_many :cards_decks
  has_many :decks, through: :cards_decks
  has_many :cards_types
  has_many :types, through: :cards_types
  has_many :cards_mtg_sets
  has_many :mtg_sets, through: :cards_mtg_sets
  validates :name, presence: true,
                   uniqueness: true
  serialize :colors
  serialize :supertypes
  serialize :subtypes

  TYPE_ORDERING = %w(
    creature
    enchantment
    instant
    sorcery
    land
    artifact
    planeswalker
  )

  def self.search(params)
    where_name_like(params[:cardname]).
    where_has_colors(params[:cardcolors]).
    where_colors_exclude(params[:cardcolors], params[:exclude]).
    where_colors_multicolor(params[:multicolor]).
    where_colors_hybrid(params[:hybrid]).
    where_colors_pherexian(params[:pherexian]).
    where_mana_gt(params[:minmana]).
    where_mana_lt(params[:maxmana]).
    where_text_contains_keywords(params[:cardtext]).
    where_has_types(params[:cardtypes])
  end

  def self.where_name_like(cardname)
    current_scope = where(nil)
    return current_scope if cardname.blank?
    where('name LIKE ?', "%#{cardname}%")
  end

  def self.where_mana_gt(min)
    current_scope = where(nil)
    return current_scope if min.blank?
    where('cmc >= ?', Integer(min))
  end

  def self.where_mana_lt(max)
    current_scope = where(nil)
    return current_scope if max.blank?
    where('cmc <= ?', Integer(max))
  end

  def self.where_colors_pherexian(in_params)
    current_scope = where(nil)
    return current_scope if in_params.blank?
    where('cost LIKE ?', "%P%")
  end

  def self.where_colors_exclude(colors, in_params)
    current_scope = where(nil)
    return current_scope if in_params.blank?
    colors_to_exclude = %w(black blue green red white) - colors
    colors_to_exclude.each do |color|
      current_scope = current_scope.where('colors NOT LIKE ?', "%#{color}%")
    end
    current_scope
  end

  def self.where_colors_multicolor(in_params)
    current_scope = where(nil)
    return current_scope if in_params.blank?
    where('colors LIKE ?', "%- %- %")
  end

  def self.where_colors_hybrid(in_params)
    current_scope = where(nil)
    return current_scope if in_params.blank?
    where('cost LIKE ?', "%/%")
  end

  def self.where_has_colors(colors)
    current_scope = where(nil)
    return current_scope if colors.blank?
    colors.each do |color|
      current_scope = current_scope.where('colors LIKE ?', "%#{color}%")
    end
    current_scope
  end

  def self.where_text_contains_keywords(keywords)
    current_scope = where(nil)
    return current_scope if keywords.blank?
    keywords.each do |keyword|
      current_scope = current_scope.where('text LIKE ?', "%#{keyword}%")
    end
    current_scope
  end

  def self.where_has_types(types)
    current_scope = where(nil)
    return current_scope if types.blank?
    types_group  = "GROUP_CONCAT(types.name)"
    having_types = "HAVING #{types_group} LIKE '%#{types.pop}%' "
    types.each do |type|
      having_types << "AND #{types_group} LIKE '%#{type}%' "
    end
    query = "
      SELECT cards.id FROM cards
      INNER JOIN cards_types ON cards.id = cards_types.card_id
      INNER JOIN types ON types.id = cards_types.type_id
      GROUP BY cards.name #{having_types}"
    where(id: connection.execute(query).map { |result| result["id"] })
  end

  def self.group_by_type(cards)
    groups = Hash.new { |h, k| h[k] = [] }
    TYPE_ORDERING.each do |type|
      groups[type] = cards.select { |card| card.types.map(&:name).include?(type) }
      groups[type].each { |card| cards -= [card] }
    end
    cards.each { |card| groups["other"] << card }
    groups
  end
end
