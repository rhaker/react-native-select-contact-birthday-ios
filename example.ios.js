/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var { NativeModules } = React;
var { RNSelectContactBirthday } = NativeModules;

var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
} = React;

var testComp = React.createClass({
  componentDidMount() {
    this._selectBirthday();
  },
  async _selectBirthday() {
    console.log('in select birthday');
    try {
      let value = await RNSelectContactBirthday.selectBirthday(true);
      console.log('Birthday: ' + value);
    } catch (error) {
      console.log('Error: ' + error.message);
    }
  },
  render: function() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Select Birthday - View Xcode Log
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('testComp', () => testComp);
