import React from 'react'
import LocalizedStrings from 'react-localization'
import I18nData from './i18n_data.json'
import Foundation from 'foundation-sites'
const $ = require("jquery")

let strings = new LocalizedStrings(I18nData);

export default class DecksPageBox extends React.Component {
  constructor() {
    super();
    this.state = {
      standardDecks: [],
      wildDecks: []
    }
  }

  componentWillMount() {
    this._fetchPageData();
    strings.setLanguage(this.props.locale);
  }

  componentDidMount() {
    $('.accordion').foundation();
  }

  _fetchPageData() {
    $.ajax({
      method: 'GET',
      url: 'decks.json',
      success: (data) => {
        this.setState({standardDecks: data.standard_decks, wildDecks: data.wild_decks});
      }
    });
  }

  _prepareRender(decks) {
    return (
      <ul className='accordion' data-accordion='' data-allow-all-closed='true'>
        {this._prepareTier(decks, 1, 10)}
        {this._prepareTier(decks, 2, 8)}
        {this._prepareTier(decks, 3, 6)}
        {this._prepareTier(decks, 4, 4)}
        {this._prepareTier(decks, 5, 2)}
      </ul>
    );
  }

  _prepareTier(decks, tier, level) {
    return (
      <li className='accordion-item' data-accordion-item=''>
        <a className='accordion-title'>Тир {tier}</a>
        <div className='accordion-content' data-tab-content=''>
          {this._prepareTierDecks(decks, level)}
        </div>
      </li>
    );
  }

  _prepareTierDecks(decks, level) {
    let tierDecks = decks.filter(function(deck){
      if (deck.power == level || deck.power == (level - 1)) return deck;
      else return false;
    });
    return tierDecks.map((deck) => {
      return (
        <div className='sub_block' key={deck.id}>
          <div className='image_block'>
            <img src={`/images/heroes/${deck.player_name}_Big.png`} />
          </div>
          <div className='text_block'>
            <div className='header'>{deck.name}</div>
            <div className='power'>Сила колоды - {deck.power}</div>
            <div className='caption'><a href={`../decks/${deck.slug}`}>Посмотреть колоду</a></div>
          </div>
        </div>
      );
    });
  }

  render() {
    return (
      <div className='decks'>
        <div className='block'>
          <h2>Колоды стандартного режима</h2>
          {this._prepareRender(this.state.standardDecks)}
        </div>
        <div className='block'>
          <h2>Колоды вольного режима</h2>
          {this._prepareRender(this.state.wildDecks)}
        </div>
      </div>
    );
  }
}
