/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.Utilities.Utilities;
import edu.uniajc.ideaBank.interfaces.IUser;
import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.ideaBank.logic.services.UserService;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ViewScoped;
import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;
import org.primefaces.context.RequestContext;
import org.primefaces.event.SelectEvent;

/**
 *
 * @author Lenovo
 */
@ManagedBean(name = "userBean")
@ViewScoped
public class UserBean implements Serializable {

    private int idTypeUser;
    private int idStateUser;
    private int idTypeId;
    private int idAcadProgr;
    private String numId;
    private String firstName;
    private String secondName;
    private String lastName;
    private String lastName2;
    private String phone;
    private String cellPhone;
    private String user;
    private String userConfirm;
    private String password;
    private String passwordConfirm;
    private String gender;
    private Date birthDate;
    private int idDepend;

    public UserBean() {
    }

    public int getIdTypeUser() {
        return idTypeUser;
    }

    public void setIdTypeUser(int idTypeUser) {
        this.idTypeUser = idTypeUser;
    }

    public int getIdStateUser() {
        return idStateUser;
    }

    public void setIdStateUser(int idStateUser) {
        this.idStateUser = idStateUser;
    }

    public int getIdTypeId() {
        return idTypeId;
    }

    public void setIdTypeId(int idTypeId) {
        this.idTypeId = idTypeId;
    }

    public String getNumId() {
        return numId;
    }

    public void setNumId(String numId) {
        this.numId = numId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getSecondName() {
        return secondName;
    }

    public void setSecondName(String secondName) {
        this.secondName = secondName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getLastName2() {
        return lastName2;
    }

    public void setLastName2(String lastName2) {
        this.lastName2 = lastName2;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCellPhone() {
        return cellPhone;
    }

    public void setCellPhone(String cellPhone) {
        this.cellPhone = cellPhone;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getUserConfirm() {
        return userConfirm;
    }

    public void setUserConfirm(String userConfirm) {
        this.userConfirm = userConfirm;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPasswordConfirm() {
        return passwordConfirm;
    }

    public void setPasswordConfirm(String passwordConfirm) {
        this.passwordConfirm = passwordConfirm;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public int getIdAcadProgr() {
        return idAcadProgr;
    }

    public void setIdAcadProgr(int idAcadProgr) {
        this.idAcadProgr = idAcadProgr;
    }

    public int getIdDepend() {
        return idDepend;
    }

    public void setIdDepend(int idDepend) {
        this.idDepend = idDepend;
    }

    
    public void newUser() {

        IUser uDao = new UserService();
        User userModel = new User();
        boolean validatorNumId;
        boolean validatorUser;
        FacesContext context = FacesContext.getCurrentInstance();
        if (this.getUser().equals(this.getUserConfirm())) {
            if (this.getPassword().equals(this.getPasswordConfirm())) {
                validatorNumId = this.getUserByNumId();
                validatorUser = this.getUserByUser();
                if (validatorUser == false && validatorNumId == false) {
                    password = Utilities.Encriptar(password);
                    userModel = uDao.createUser(idTypeUser, 1, idTypeId, numId, firstName,
                            secondName, lastName, lastName2, phone, cellPhone, user,
                            password, gender, birthDate, idAcadProgr, idDepend);
                    if (userModel == null) {
                        context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                "Los datos no fueron guardados.", ""));
                    } else {
                        context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                                "Los datos fueron guardados.", ""));
                            RequestContext.getCurrentInstance().execute("PF('dialogOk').show()");
                    }
                } else if (validatorUser == true) {
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                            "El correo electronico ya se encuentra registrado.", ""));
                } else {
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                            "El numero de identificación ya se encuentra registrado.", ""));
                }

            } else {
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                        "Las contraseñas no corresponden", ""));
            }

        } else {
            context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                    "Los correos electronicos no son iguales", ""));
        }

    }

    public boolean getUserByUser() {
        IUser uDao = new UserService();
        boolean validator = uDao.getUserByUser(this.getUser());
        return validator;
    }

    public boolean getUserByNumId() {
        IUser uDao = new UserService();
        boolean validator = uDao.getUserByNumId(this.getNumId());
        return validator;
    }

    public void linklogin() {
        FacesContext context = FacesContext.getCurrentInstance();
        try {
            context.getExternalContext().redirect("login.xhtml");
        } catch (Exception e) {
        }

    }
    
    public void onDateSelect(SelectEvent event) {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
        facesContext.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Date Selected", format.format(event.getObject())));
    }
     
    public void click() {
        RequestContext requestContext = RequestContext.getCurrentInstance();
         
        requestContext.update("form:display");
        requestContext.execute("PF('dlg').show()");
    }
}
