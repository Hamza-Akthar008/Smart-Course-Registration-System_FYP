import { DataTypes } from 'sequelize';
import {sequelize} from '../config/dbconfig.js'; 

const Course = sequelize.define('Course', {
  CourseID: {
    type: DataTypes.STRING,
    primaryKey: true,
    allowNull: false,
  },
  Course_Name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  Course_Type: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  Course_Description: {
    type: DataTypes.STRING,
  },
});

export default Course;
